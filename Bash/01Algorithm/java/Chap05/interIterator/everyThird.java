class InterIterApp
   {
   public static void main(String[] args) throws IOException
      {
      LinkList theList = new LinkList();           // new list
      ListIterator iter1 = theList.getIterator();  // new iter

      iter1.insertAfter(21);            // insert links
      iter1.insertAfter(40);
      iter1.insertAfter(30);
      iter1.insertAfter(7);
      iter1.insertAfter(45);

      theList.displayList();            // display list

      iter1.reset();                    // start at first link
      Link aLink = iter1.getCurrent();  // get link
      if(aLink.dData % 3 == 0)          // if divisible by 3,
         iter1.deleteCurrent();         // delete it
      while( !iter1.atEnd() )           // until end of list,
         {
         iter1.nextLink();              // go to next link

         aLink = iter1.getCurrent();    // get link
         if( aLink.dData % 3 == 0)      // if divisible by 3,
            iter1.deleteCurrent();      // delete it
         }
      theList.displayList();            // display list
      }  // end main()
//--------------------------------------------------------------
   }  // end class InterIterApp
