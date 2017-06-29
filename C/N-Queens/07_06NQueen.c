/**
  Cで学ぶアルゴリズムとデータ構造  
  ステップバイステップでＮ−クイーン問題を最適化
  一般社団法人  共同通信社  情報技術局  鈴木  維一郎(suzuki.iichiro@kyodonews.jp)
  
   １．ブルートフォース（力まかせ探索） NQueen01()
   ２．配置フラグ（制約テスト高速化）   NQueen02()
   ３．バックトラック                   NQueen03() N17: 8:05
   ４．対称解除法(回転と斜軸）          NQueen04() N17: 7:54
   ５．枝刈りと最適化                   NQueen05() N17: 2:14
 <>６．ビットマップ                     NQueen06() N17: 1:30
   ７．ビットマップ+対称解除法          NQueen07() N17: 2:24
   ８．ビットマップ+クイーンの場所で分岐NQueen08() N17: 1:26
   ９．ビットマップ+枝刈りと最適化      NQueen09() N17: 0:16
   10．もっとビットマップ(takaken版)    NQueen10() N17: 0:10
   11．マルチスレッド(構造体)           NQueen11() N17: 0:14
   12．マルチスレッド(pthread)          NQueen12() N17: 0:13
   13．マルチスレッド(join)             NQueen13() N17: 0:17
   14．マルチスレッド(mutex)            NQueen14() N17: 0:27
   15．マルチスレッド(アトミック対応)   NQueen15() N17: 0:05
   16．アドレスとポインタ               NQueen16() N17: 0:04
   17．アドレスとポインタ(脱構造体)     NQueen17() N17: 

 # Java/C/Lua/Bash版
 # https://github.com/suzukiiichiro/N-Queen
 

 ６．ビットマップ
   ビット演算を使って高速化 状態をビットマップにパックし、処理する
   単純なバックトラックよりも２０〜３０倍高速
 
 　ビットマップであれば、シフトにより高速にデータを移動できる。
  フラグ配列ではデータの移動にO(N)の時間がかかるが、ビットマップであればO(1)
  フラグ配列のように、斜め方向に 2*N-1の要素を用意するのではなく、Nビットで充
  分。

 　配置可能なビット列を flags に入れ、-flags & flags で順にビットを取り出し処理。
 　バックトラックよりも２０−３０倍高速。
 
 ===================
 考え方 1
 ===================

 　Ｎ×ＮのチェスボードをＮ個のビットフィールドで表し、ひとつの横列の状態をひと
 つのビットフィールドに対応させます。(クイーンが置いてある位置のビットをONに
 する)
 　そしてバックトラッキングは0番目のビットフィールドから「下に向かって」順にい
 ずれかのビット位置をひとつだけONにして進めていきます。

 
  - - - - - Q - -    00000100 0番目のビットフィールド
  - - - Q - - - -    00010000 1番目のビットフィールド
  - - - - - - Q -    00000010 2番目のビットフィールド
  Q - - - - - - -    10000000 3番目のビットフィールド
  - - - - - - - Q    00000001 4番目のビットフィールド
  - Q - - - - - -    01000000 5番目のビットフィールド
  - - - - Q - - -    00001000 6番目のビットフィールド
  - - Q - - - - -    00100000 7番目のビットフィールド


 ===================
 考え方 2
 ===================

 次に、効き筋をチェックするためにさらに３つのビットフィールドを用意します。

 1. 左下に効き筋が進むもの: left 
 2. 真下に効き筋が進むもの: down
 3. 右下に効き筋が進むもの: right

次に、斜めの利き筋を考えます。
 上図の場合、
 1列目の右斜め上の利き筋は 3 番目 (0x08)
 2列目の右斜め上の利き筋は 2 番目 (0x04) になります。
 この値は 0 列目のクイーンの位置 0x10 を 1 ビットずつ「右シフト」すれば求める
 ことができます。
 また、左斜め上の利き筋の場合、1 列目では 5 番目 (0x20) で 2 列目では 6 番目 (0x40)
になるので、今度は 1 ビットずつ「左シフト」すれば求めることができます。

つまり、右シフトの利き筋を right、左シフトの利き筋を left で表すことで、クイー
ンの効き筋はrightとleftを1 ビットシフトするだけで求めることができるわけです。

  *-------------
  | . . . . . .
  | . . . -3. .  0x02 -|
  | . . -2. . .  0x04  |(1 bit 右シフト right)
  | . -1. . . .  0x08 -|
  | Q . . . . .  0x10 ←(Q の位置は 4   down)
  | . +1. . . .  0x20 -| 
  | . . +2. . .  0x40  |(1 bit 左シフト left)  
  | . . . +3. .  0x80 -|
  *-------------
  図：斜めの利き筋のチェック

 n番目のビットフィールドからn+1番目のビットフィールドに探索を進めるときに、そ
 の３つのビットフィールドとn番目のビットフィールド(bit)とのOR演算をそれぞれ行
 います。leftは左にひとつシフトし、downはそのまま、rightは右にひとつシフトして
 n+1番目のビットフィールド探索に渡してやります。

 left : (left |bit)<<1
 right: (right|bit)>>1
 down :   down|bit


 ===================
 考え方 3
 ===================

   n+1番目のビットフィールドの探索では、この３つのビットフィールドをOR演算した
 ビットフィールドを作り、それがONになっている位置は効き筋に当たるので置くことが
 できない位置ということになります。次にその３つのビットフィールドをORしたビッ
 トフィールドをビット反転させます。つまり「配置可能なビットがONになったビットフィー
 ルド」に変換します。そしてこの配置可能なビットフィールドを bitmap と呼ぶとして、
 次の演算を行なってみます。
 
 bit = -bitmap & bitmap; //一番右のビットを取り出す
 
   この演算式の意味を理解するには負の値がコンピュータにおける２進法ではどのよう
 に表現されているのかを知る必要があります。負の値を２進法で具体的に表わしてみる
 と次のようになります。
 
  00000011   3
  00000010   2
  00000001   1
  00000000   0
  11111111  -1
  11111110  -2
  11111101  -3
 
   正の値nを負の値-nにするときは、nをビット反転してから+1されています。そして、
 例えばn=22としてnと-nをAND演算すると下のようになります。nを２進法で表したときの
 一番下位のONビットがひとつだけ抽出される結果が得られるのです。極めて簡単な演算
 によって1ビット抽出を実現させていることが重要です。
 
      00010110   22
  AND 11101010  -22
 ------------------
      00000010
 
   さて、そこで下のようなwhile文を書けば、このループは bitmap のONビットの数の
 回数だけループすることになります。配置可能なパターンをひとつずつ全く無駄がなく
 生成されることになります。
 
 while (bitmap) {
     bit = -bitmap & bitmap;
     bitmap ^= bit;
     //ここでは配置可能なパターンがひとつずつ生成される(bit) 
 }


  実行結果
 N:        Total       Unique        dd:hh:mm:ss
 2:            0               0      0 00:00:00
 3:            0               0      0 00:00:00
 4:            2               1      0 00:00:00
 5:           10               2      0 00:00:00
 6:            4               1      0 00:00:00
 7:           40               6      0 00:00:00
 8:           92              12      0 00:00:00
 9:          352              46      0 00:00:00
10:          724              92      0 00:00:00
11:         2680             341      0 00:00:00
12:        14200            1787      0 00:00:00
13:        73712            9233      0 00:00:00
14:       365596           45752      0 00:00:01
15:      2279184          285053      0 00:00:02
16:     14772512         1846955      0 00:00:13
 */
#include<stdio.h>
#include<time.h>
#include <math.h>

#define MAXSIZE 27

int lTotal=1 ; //合計解
int lUnique=0; //ユニーク解
int iSize;     //Ｎ
int aBoard[MAXSIZE];  //チェス盤の横一列
int aTrial[MAXSIZE];
int aScratch[MAXSIZE];
int iMask;
int bit;
int COUNT2=0; int COUNT4=0; int COUNT8=0;

void TimeFormat(clock_t utime,char *form){
    int dd,hh,mm;
    float ftime,ss;
    ftime=(float)utime/CLOCKS_PER_SEC;
    mm=(int)ftime/60;
    ss=ftime-(int)(mm*60);
    dd=mm/(24*60);
    mm=mm%(24*60);
    hh=mm/60;
    mm=mm%60;
    sprintf(form,"%7d %02d:%02d:%02.0f",dd,hh,mm,ss);
}
long getUnique(){ 
  return COUNT2+COUNT4+COUNT8;
}
long getTotal(){ 
  return COUNT2*2+COUNT4*4+COUNT8*8;
}
void rotate(int check[],int scr[],int n,int neg){
  int k=neg?0:n-1;
  int incr=(neg?+1:-1);
  for(int j=0;j<n;k+=incr){ scr[j++]=check[k];}
  k=neg?n-1:0;
  for(int j=0;j<n;k-=incr){ check[scr[j++]]=k;}
}
void vMirror(int check[]){
  for(int j=0;j<iSize;j++){ check[j]=(iSize-1)- check[j];}
}
int intncmp(int lt[],int rt[]){
  int rtn=0;
  for(int k=0;k<iSize;k++){
    rtn=lt[k]-rt[k];
    if(rtn!=0){ break;}
  }
  return rtn;
}
void symmetryOps(int bitmap){
  int nEquiv;
  // 回転・反転・対称チェックのためにboard配列をコピー
  for(int i=0;i<iSize;i++){ aTrial[i]=aBoard[i];}
  rotate(aTrial,aScratch,iSize,0);  //時計回りに90度回転
  int k=intncmp(aBoard,aTrial);
  if(k>0)return;
  if(k==0){ nEquiv=2;}else{
    rotate(aTrial,aScratch,iSize,0);//時計回りに180度回転
    k=intncmp(aBoard,aTrial);
    if(k>0)return;
    if(k==0){ nEquiv=4;}else{
      rotate(aTrial,aScratch,iSize,0);//時計回りに270度回転
      k=intncmp(aBoard,aTrial);
      if(k>0){ return;}
      nEquiv=8;
    }
  }
  // 回転・反転・対称チェックのためにboard配列をコピー
  for(int i=0;i<iSize;i++){ aTrial[i]=aBoard[i];}
  vMirror(aTrial);    //垂直反転
  k=intncmp(aBoard,aTrial);
  if(k>0){ return; }
  if(nEquiv>2){             //-90度回転 対角鏡と同等       
    rotate(aTrial,aScratch,iSize,1);
    k=intncmp(aBoard,aTrial);
    if(k>0){return;}
    if(nEquiv>4){           //-180度回転 水平鏡像と同等
      rotate(aTrial,aScratch,iSize,1);
      k=intncmp(aBoard,aTrial);
      if(k>0){ return;}  //-270度回転 反対角鏡と同等
      rotate(aTrial,aScratch,iSize,1);
      k=intncmp(aBoard,aTrial);
      if(k>0){ return;}
    }
  }
  if(nEquiv==2){ COUNT2++; }
  if(nEquiv==4){ COUNT4++; }
  if(nEquiv==8){ COUNT8++; }
}
void NQueen(int y, int left, int down, int right){
  int bitmap=iMask&~(left|down|right); /* 配置可能フィールド */
  if (y==iSize) {
    if(!bitmap){
	    aBoard[y]=bitmap;
			//ベタにビットの配列を 元のaBoardにいったん戻してみた 
			int v[MAXSIZE];
			for (int i=0;i<iSize;i++){
				v[i]=aBoard[i];
				aBoard[i]=iSize-1-log2(aBoard[i]);
			}
      //対称解除法による解析(まだビット対応してない）
			symmetryOps(bitmap);
			//処理が終わったら元のビットの配列に戻す
			for (int i=0;i<iSize;i++){ aBoard[i]=v[i]; }
    }
  }else{
    while (bitmap) {
      bitmap^=aBoard[y]=bit=(-bitmap&bitmap); //最も下位の１ビットを抽出
      NQueen(y+1,(left|bit)<<1,down|bit,(right|bit)>>1);
     }
  } 
}
int main(void){
  clock_t st; char t[20];
  printf("%s\n"," N:        Total       Unique        dd:hh:mm:ss");
  for(int i=2;i<=MAXSIZE;i++){
    iSize=i; lTotal=0; lUnique=0;
    COUNT2=0;COUNT4=0;COUNT8=0;
    for(int j=0;j<iSize;j++){ aBoard[j]=j; }
    st=clock();
    iMask=(1<<iSize)-1; // 初期化
    NQueen(0,0,0,0);
    TimeFormat(clock()-st,t);
    printf("%2d:%13ld%16ld%s\n",iSize,getTotal(),getUnique(),t);
  } 
}

