/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */

.global balance,transaction,eat_out,stay_in,eat_ice_cream,we_have_a_problem
.type balance,%gnu_unique_object
.type transaction,%gnu_unique_object
.type eat_out,%gnu_unique_object
.type stay_in,%gnu_unique_object
.type eat_ice_cream,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
balance:           .word     0  /* input/output value */
transaction:       .word     0  /* output value */
eat_out:           .word     0  /* output value */
stay_in:           .word     0  /* output value */
eat_ice_cream:     .word     0  /* output value */
we_have_a_problem: .word     0  /* output value */

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: the integer value returned to the C function
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    LDR r1,=balance
    LDR r2,[r1]
    ADD r0,r0,r2
.endif
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    
    /* ALL OUR REGSITERS ARE AS FOLLOWS
     * R0 - for user input/output
     * R1 - balance
     * R2 - transaction
     * R3 - eat_out
     * R4 - stay_in
     * R5 - eat_ice_cream
     * R6 - we_have_a_problem
     * R7 - tmpBalance
     * R8 - scratch pad 1
     * R9 - scratch pad 2
     * R10 - stores 0
     * R11 - stores 1 for easy ADDS to reset flags
     * R12 - stores result of our easy ADDS
     */
    
    /* reset our flags */
    LDR R11,=1
    ADDS R12,R11,R11
    
    /* set each output variable to a register */
    LDR R1,=balance
    LDR R2,=transaction
    LDR R3,=eat_out
    LDR R4,=stay_in
    LDR R5,=eat_ice_cream
    LDR R6,=we_have_a_problem
    
    /* set output variables to 0 (except for balance) */
    LDR R10,=0
    STR R10,[R2]
    STR R10,[R3]
    STR R10,[R4]
    STR R10,[R5]
    STR R10,[R6]
    
    /* copy R0 to transaction */
    STR R0,[R2]
    
    /* loading scratch pad registers */
    LDR R8,=1000
    LDR R9,=-1000
    /* check if value put in transaction is greater than 1000 */
    CMP R0,R8
    /* and if so branch to not_acceptable */
    BGT not_acceptable
    /* check if value put in transation is less than -1000 */
    CMP R0,R9
    /* and if so branch to not_acceptable */
    BLT not_acceptable
    
    /* R7 is gonna be tmpBalance
     * tmpBalance is = balance + transation
     */
    LDR R8,[R1]
    LDR R9,[R2]
    ADDS R7,R8,R9
    /* check for overflow and skip to not_acceptable if the case */
    BVS not_acceptable
    
    /* set balance to our calculated tempBalance */
    STR R7,[R1]
    
    /* reset flags just in case */
    ADDS R12,R11,R11
    
    /* compare balance to 0 */
    LDR R8,[R1]
    CMP R8,R10
    /* if it's larger than 0, set eat_out to 1 */
    STRGT R11,[R3]
    /* if it's small than 0, set stay_in to 1 */
    STRLT R11,[R4]
    /* as long as it's not 0, branch to almost_done */
    BNE almost_done
    
    /* if it is 0, eat_ice_cream = 1 & branch to almost_done */
    STR R11,[R5]
    B almost_done
    
/* not_accptable branch 
 * for if transaction is... not_acceptable 
 */   
not_acceptable:
    /* transaction = 0 */
    STR R10,[R2]
    /* we_have_a_problem = 1 */
    STR R11,[R6]
    /* set R0 to our balance */
    LDR R0,[R1]
    /* after this we go to done 
     * skipping over almost_done
     */
    B done
    
/* almost done branch */
almost_done:
    /* load our balance into R0*/
    LDR R0,[R1]
    /* no need ot branch to done as that's the next line anyways */
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




