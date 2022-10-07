EXPORT Bit(UNSIGNED1 n, UNSIGNED1 b=0) := MODULE
  /**
   * Returns a single-bit pattern. 
   *
   * @param n           The ordinal position of the single bit(1-8). 
   * @param b           Ignored
   * @return            The bit pattern with 1 in the n position.
   */
  EXPORT UNSIGNED1 Bit := IF(n BETWEEN 1 AND 8,00000001b << (n-1),0);
  //   00000001b << (n-1) is equivalent to using:
  // SET OF UNSIGNED1 BitSet := [1,2,4,8,16,21,64,128];
  //   or:
  // SET OF UNSIGNED1 BitSet := [00000001b,
                              // 00000010b,
                              // 00000100b,
                              // 00001000b,
                              // 00010000b,
                              // 00100000b,
                              // 01000000b,
                              // 10000000b];

  /**
   * Sets or resets a single bit. 
   *
   * @param n           The ordinal position of the single bit to toggle (1-8). 
   * @param b           The bit pattern containing the bit to set/reset.
   * @return            An UNSIGNED1 with the nth bit toggled.
   */
  EXPORT OnOff := b ^ Bit;   

  /**
   * Tests a single bit. 
   *
   * @param n           The ordinal position of the single bit to test (1-8). 
   * @param b           The bit pattern containing the bit to test.
   * @return            TRUE if the nth bit is on (1).
   */
  EXPORT IsSet := b & Bit = Bit; 

  /**
   * Tests a bit pattern for all passed bits on. 
   *
   * @param n           The bit pattern to match (0-255). 
   * @param b           The bit pattern to test against.
   * @return            TRUE if all 1 bits in n are also 1 in the b pattern.
   */
  EXPORT AreSet := b & n = n;    

END;	
//test queries you can run in a new builder window:
// IMPORT Util;
// Util.Bit(1).OnOff;          //set bit 1    =1 (00000001b)
// Util.Bit(1,1).OnOff;        //reset bit 1  =0 (00000000b)
// Util.Bit(2).OnOff;          //set bit 2    =2 (00000010b)
// Util.Bit(3).OnOff;          //set bit 3    =4 (00000100b)
// Util.Bit(1,1).IsSet;        //true  (00000001b  = 00000001b)
// Util.Bit(1,2).IsSet;        //false (00000001b != 00000010b)
// Util.Bit(1,3).IsSet;        //true  (00000011b has bit 1 set)
