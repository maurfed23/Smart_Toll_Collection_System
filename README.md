1. Inputs to the Smart Toll Collection System
clk(1 bit)	                                Clock System clock;
rst(1 bit)	                                Control Synchronous reset;
transaction_valid(1 bit) 	                Control	Indicates a new vehicle transaction;
tag_id(8 bits)  	                        Data RFID/electronic toll tag ID;
vehicle_type(2 bits)	                    Data Identifies vehicle category;
balance(12 bits)	                        Data Available account balance;


2. Outputs
toll_amount(12 bits)                        Toll calculated for the vehicle;
remaining_balance(12 bits)  	            Balance after successful deduction;
transaction_done(1 bit)                     Indicates transaction processing has finished;
transaction_accepted(1 bit)                 Indicates successful transaction;
error(1 bit)                                Indicates transaction failure;
error_code(2 bits)                          Indicates reason for failure;

3. VEHICLE_CLASSES:
00 → Car       → 50;
01 → Bus       → 100;
10 → Truck     → 150;
11 → Heavy     → 200;

4. Error-code parameters

We have four possible 2-bit error codes:

localparam reg [1:0] NO_ERROR             = 2'b00;
localparam reg [1:0] INVALID_TAG          = 2'b01;
localparam reg [1:0] INSUFFICIENT_BALANCE = 2'b10;
localparam reg [1:0] INVALID_TRANSACTION  = 2'b11;

5. State register

Our FSM has 8 states, therefore we use a 3-bit state register.



    IDLE          = 3'd0,
    INPUT_CAPTURE = 3'd1,
    TAG_VALIDATE  = 3'd2,
    TOLL_CALC     = 3'd3,
    BALANCE_CHECK = 3'd4,
    DEDUCT        = 3'd5,
    DONE          = 3'd6,
    ERROR_STATE   = 3'd7


6. Internal Registers:
   current_state;
   next_state;

7. FSM states
IDLE	           000	                       Wait for new transaction;
INPUT_CAPTURE	   001	                       Transaction information is captured;
TAG_VALIDATE	   010	                       Check whether tag is valid;
TOLL_CALC	       011	                       Determine toll based on vehicle;
BALANCE_CHECK	   100	                       Check whether balance is sufficient;
DEDUCT	           101	                       Deduct toll from balance;
DONE	           110	                       Successful transaction completed;
ERROR_STATE	       111	                       Transaction failed;



smart_toll_top
│
├── Input registers
│   ├── tag_id_reg
│   ├── vehicle_type_reg
│   └── balance_reg
│
├── FSM
│   ├── IDLE
│   ├── INPUT_CAPTURE
│   ├── TAG_VALIDATE
│   ├── TOLL_CALC
│   ├── BALANCE_CHECK
│   ├── DEDUCT
│   ├── DONE
│   └── ERROR
│
├── Toll calculation logic
│
└── Output registers
    ├── toll_amount
    ├── remaining_balance
    ├── transaction_done
    ├── transaction_accepted
    ├── error
    └── error_code




MODULE Flip_Flops:
input_register.v - 23 Flip Flops;
tag_validator.v - 0 Flip Flops;
toll_calculator.v - 0 Flip Flops;
Toll amount register(inside Top module.....not a separate module) - 12 Flip Flops;
toll_controller.v - 3 Flip Flops;
transaction_processor.v - 12 Flip Flops;
output_register.v - 5 Flip Flops;

Total Flip Flops - 55 Flip FLops;


And the three purely combinational blocks are:
Tag Validator
Toll Calculator
Balance Comparator
