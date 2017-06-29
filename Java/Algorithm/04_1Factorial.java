// Factorial.java
// 階乗値を再帰的に求める
// to run this program: java Factorial
import java.util.Scanner ;
////////////////////////////////////////////////////////////////
class Factorial {
  static int factorial(int n){
    if ( n > 0 ){
      return n * factorial ( n - 1 ) ;
    }else{
      return 1 ;
    }
  } 
  public static void main(String[] args){
    Scanner stdIn = new Scanner(System.in) ;
    System.out.print("整数値を入力せよ: ") ;
    int x = stdIn.nextInt() ;
    System.out.println( x + "の階乗値は" + factorial(x) + "です。") ;
  }
}
