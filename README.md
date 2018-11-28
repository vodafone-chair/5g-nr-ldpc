# 5g-nr-ldpc
This library implements a basic version of the 5G NR LDPC code as specified in [TS38.212](https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=3214). The decoder implements the sum-product algorithm and is based on [1].

## Quick start
The file [`ldpcExample.m`](https://github.com/vodafone-chair/5g-nr-ldpc/blob/master/ldpcExample.m) provides a minimal working example of encoding and decoding.

## Features
So far the implementation supports the block lengths `N=[264, 544, 1056, 2176, 4224, 8448]` and code rates `R=[1/3, 1/2, 2/3, 3/4, 5/6]`. Note that the development is not finished. Extension to more code rates and other block lengths are easily possible. The implementation includes the base graphs 1 and 2.

## References 
[1] E. Sharon, S. Litsyn and J. Goldberger, "An efficient message-passing schedule for LDPC decoding," 2004 23rd IEEE Convention of Electrical and Electronics Engineers in Israel, Tel-Aviv, Israel, 2004, pp. 223-226.
