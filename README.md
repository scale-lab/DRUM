# DRUM: A Dynamic Range Unbiased Multiplier for Approximate Applications

DRUM stands for Dynamic Range Unbiased Multiplier, and proposes an efficient approximate multiplier
to be utilized in error tolerant applications. DRUM has three main features. First, the design utilizes
a dynamic selections scheme where the most important bits of each operand are guaranteed to be selected.
Second, DRUM features a unbiased error distribution where the average error is very closely centred
around zero. This feature results in errors cancelling each other out rather than accumulate when results
of few multiplications are added together. And third, the multiplier is design-time configurable,
enabling the designer to choose from a range of different accuracy vs. power benefits trade-offs.
Here, we provide the Verilog files for a few of different designs as proposed in our work [1].
 
For more details please visit our publication:

[1] S. Hashemi, R. I. Bahar and S. Reda, "DRUM: A Dynamic Range Unbiased Multiplier for Approximate
Applications", in ACM/IEEE International Conference on Computer-Aided Design (ICCAD), 2015.

# Files in The Repository

- DRUMk_N_x.v: Contains source code for the approximate multiplier DRUM. In file name, k is the number
  of bits selected from each operand, n is the multiplier bit-width, and x is either s or u for signed
  or unsigned multiplication. For demonstration source codes for, four different values of k, two
  different input widths, and both signed and unsigned operations are provided.
- Schem.pdf: Figure 3 from the paper. Shows the simplified schematics of the approximate multiplier.
- LICENSE: Contains the license information.
- README.md: The README file. This file.

# Code Description

The source code has been written in a modular Verilog. Here are the modules used in DRUM6_16_s.v:

* DRUM6_16_s: The topmodule. Connects all of the module instances together.

* DRUM6_16_u: The unsigned version of the same approximate multiplier.

* LOD: The Leading One Detector. The output of this block is a number with only one 1 showing the 
  location of the leading one. For example, 16'b0010_0101_1110_1111 will be 16'b0010_0000_0000_0000.

* P_Encoder: A priority encoder. Encodes the output of LOD to Log(n) bits. In the previous example,
  the output will be 4'b1101.

* Mux_16_3: The multiplexer responsible for selecting k-2 bits from each of the two operands, starting
  from most significant 1. In the example the output is 4'b0010.

* Barrel_Shifter: Shifts the results of the multiplications to the right index, therefore, generating
  the final result.

# License and Citation

DRUM source code is released under the BSD 2-Clause license.(Refer to LICENSE file).

Please cite DRUM in your publications if it helps your research:

  @inproceedings{Hashemi_DRUM,
     author = {Hashemi, Soheil and Bahar, R. Iris and Reda, Sherief},
     title = {DRUM: A Dynamic Range Unbiased Multiplier for Approximate Applications},
     booktitle = {Proceedings of the IEEE/ACM International Conference on Computer-Aided Design},
     series = {ICCAD '15},
     year = {2015},
  } 

Contact [soheil_hashemi at brown.edu], or [sherief_reda at brown.edu] for questions.