EXPORT Bits := MODULE
  /**
   * Converts an UNSIGNED1 bit pattern to a string. 
   *
   * @param b           The UNSIGNED1 bit pattern to convert.
   * @return            A 9-character string showing the binary 
	 *                    represenation of the b parameter.
   */
/*    The first is a function to show the bitmap as a binary string, because sometimes it helps to visualize 
      exactly which bits are on and off to understand whether your code is producing the correct results. 
*/
  EXPORT STRING9 ShowStr(UNSIGNED1 b) := FUNCTION
    Chk(c) := IF($.Bit(c,b).IsSet,'1','0');
	  RETURN Chk(8) + Chk(7) + Chk(6) + Chk(5) + 
           Chk(4) + Chk(3) + Chk(2) + Chk(1) + 'b';
  END;
	
  /**
   * Returns all numbers with matching bit patterns. 
   *
   * @param pat         The UNSIGNED1 bit pattern to match (0-255). 
   * @return            A SET of all numbers where all 1 bits in 
	 *                    the pat parameter are also 1 in the number.
   */
   // This function produces a set of all numbers (1-255) that contain a specific set of bits turned on.
  EXPORT NumSet(UNSIGNED1 pat) := FUNCTION
    {UNSIGNED1 val} XF(INTEGER C) := TRANSFORM
      SELF.val := IF($.Bit(pat,C).AreSet,C,SKIP);
    END;
    ds := DATASET(255,XF(COUNTER));
    // ds := DATASET(255,TRANSFORM({UNSIGNED1 val},
         // SELF.val := IF($.Bit(pat,COUNTER).AreSet,
			                   // COUNTER,SKIP)));
    RETURN SET(ds,val);
  END;
END;

// Util.Bits.ShowStr(15);        //00001111b
// Util.Bits.NumSet(11111110b);  //[254,255]
