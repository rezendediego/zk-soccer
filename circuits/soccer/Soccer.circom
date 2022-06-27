/**
° ZKUniversity - Final Project circuit for Assignment 7 
° ZK-SOCCER 
° @author Diego Rezende | e-mail: diegorezende.ce@gmail.com   discord: diegorezende#2184
° June 6, 2022.
°
**/

/*

                            +---------------------------+    
                              |\                          |\   
                              | \    @ \_    /            | \
                              |  \  /  \_o--<_/           | o\
______________________________|___|/______________________|-|\|__________________
         /                   /    /              _ o     / /|_                /
        /                   /  _o'------------- / / \ ----/                  /
       /                   /  /|_                /\    /                    /
      /                   /_ /\ _______________ / / __/                    /
     /                      / /                                           /
    /                                                                    /
   /                                                                    /
  /                                                                    /
 /____________________________________________________________________/
 
.%%%%%%..%%..%%...%%%%....%%%%....%%%%....%%%%...%%%%%%..%%%%%..
....%%...%%.%%...%%......%%..%%..%%..%%..%%..%%..%%......%%..%%.
...%%....%%%%.....%%%%...%%..%%..%%......%%......%%%%....%%%%%..
..%%.....%%.%%.......%%..%%..%%..%%..%%..%%..%%..%%......%%..%%.
.%%%%%%..%%..%%...%%%%....%%%%....%%%%....%%%%...%%%%%%..%%..%%.
................................................................

Reference:
art_source: https://www.asciiart.eu/sports-and-outdoors/soccer
typography: https://www.askapache.com/online-tools/figlet-ascii/
*/

pragma circom 2.0.4;

include "./Soccer-base.circom";

component main {public [fieldLayerMode]} = Soccer();