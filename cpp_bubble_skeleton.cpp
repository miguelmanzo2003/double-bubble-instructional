//
// template C++ code for doing bubblesort, W. Bethel, SFSU, 2/2023
//
// Miguel Manzo
// CSC656, Coding Project #1
// September 10, 2025
// 1-sentence description here: Use bubble sort to sort an array of 10 integers using a subroutine function
//

#include <iostream>
#include <unistd.h>


void print_array(int A[], int n){
   for(int i = 0; i < n; i++){
      std::cout << A[i] << " ";
   }
   std::cout << "\n";
}

int bubble_sort_inner(int A[], int N){

   int changed = 0;
   for(int j = 0; j < N; j++){

         if(A[j] > A[j+1]){
           int temp = A[j];
           A[j] = A[j+1];
           A[j+1]= temp;
           changed = 1;
           print_array(A, N);
         }
        
   }
   
   return changed;
}


int main (int ac, char *av[])
{
   int a[] = {-2, -1, 0, 92, 52, 27, 86, 6, 52, 35}; // replace with your own random 10 ints from www.calculator.net/random-number-generator.html
   int n = sizeof(a)/sizeof(int);
   

   std::cout << " a before sort "<< std::endl;

   // print out the contents of a before the sort
   // insert your code here
   print_array(a, n);
   

   // do the sort into ascending order. 
   // insert your code here
   for(int i = 0; i < n-1; i++){



      print_array(a, n);
      int changed = bubble_sort_inner(a, n-i-1);
      print_array(a, n);

      if(changed == 0){
         std::cout << "no changes were made\n\n";
         break;
      }

   }


   // print out the contents of a after the sort
   // insert your code here
   print_array(a, n);
   return 0;
}
// EOF
