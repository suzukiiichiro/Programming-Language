// Euclid.java
// ユークリッドの互除法によって最大公約数を求める
// to run this program: java EuclidGCD

import java.util.Scanner ;
//////////////////////////////////////////////////////////////
class EuclidGCD{
  static int gcd(int x , int y){
    if ( y == 0 ){
      return x ;
    }else{
      return gcd(y, x % y) ;
    }
  }
  public static void main(String[] args){
    Scanner stdIn = new Scanner(System.in) ;
    System.out.println("二つの整数の最大公約数を求めます。") ;
    System.out.print("整数を入力せよ：") ;
      int x = stdIn.nextInt() ;
    System.out.print("整数を入力せよ：") ;
      int y = stdIn.nextInt() ;
    System.out.println("最大公約数は" + gcd(x, y) +"です。") ;
  }
}

