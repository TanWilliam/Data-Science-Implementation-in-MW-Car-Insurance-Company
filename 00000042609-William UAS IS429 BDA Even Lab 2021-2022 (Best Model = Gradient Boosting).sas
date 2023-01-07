/*---------------------------------------------------------
  The options statement below should be placed
  before the data step when submitting this code.
---------------------------------------------------------*/
options VALIDMEMNAME=EXTEND VALIDVARNAME=ANY;


/*---------------------------------------------------------
  Before this code can run you need to fill in all the
  macro variables below.
---------------------------------------------------------*/
/*---------------------------------------------------------
  Start Macro Variables
---------------------------------------------------------*/
%let SOURCE_HOST=<Hostname>; /* The host name of the CAS server */
%let SOURCE_PORT=<Port>; /* The port of the CAS server */
%let SOURCE_LIB=<Library>; /* The CAS library where the source data resides */
%let SOURCE_DATA=<Tablename>; /* The CAS table name of the source data */
%let DEST_LIB=<Library>; /* The CAS library where the destination data should go */
%let DEST_DATA=<Tablename>; /* The CAS table name where the destination data should go */

/* Open a CAS session and make the CAS libraries available */
options cashost="&SOURCE_HOST" casport=&SOURCE_PORT;
cas mysess;
caslib _all_ assign;

/* Load ASTOREs into CAS memory */
proc casutil;
  Load casdata="Gradient_boosting___DRIVING_EXPERIENCE_1.sashdat" incaslib="Models" casout="Gradient_boosting___DRIVING_EXPERIENCE_1" outcaslib="casuser" replace;
Quit;

/* Apply the model */
proc cas;
  fcmpact.runProgram /
  inputData={caslib="&SOURCE_LIB" name="&SOURCE_DATA"}
  outputData={caslib="&DEST_LIB" name="&DEST_DATA" replace=1}
  routineCode = "

   /*------------------------------------------
   Generated SAS Scoring Code
     Date             : 09Jun2022:04:42:33
     Locale           : en_US
     Model Type       : Gradient Boosting
     Interval variable: PAST_ACCIDENTS
     Interval variable: SPEEDING_VIOLATIONS
     Interval variable: VEHICLE_OWNERSHIP
     Interval variable: MARRIED
     Interval variable: ANNUAL_MILEAGE
     Class variable   : DRIVING_EXPERIENCE
     Class variable   : VEHICLE_TYPE
     Class variable   : RACE
     Class variable   : GENDER
     Class variable   : VEHICLE_YEAR
     Response variable: DRIVING_EXPERIENCE
     ------------------------------------------*/
declare object Gradient_boosting___DRIVING_EXPERIENCE_1(astore);
call Gradient_boosting___DRIVING_EXPERIENCE_1.score('CASUSER','Gradient_boosting___DRIVING_EXPERIENCE_1');
   /*------------------------------------------*/
   /*_VA_DROP*/ drop 'I_DRIVING_EXPERIENCE'n 'P_DRIVING_EXPERIENCE0_9y'n 'P_DRIVING_EXPERIENCE10_19y'n 'P_DRIVING_EXPERIENCE20_29y'n 'P_DRIVING_EXPERIENCE30y_'n;
length 'I_DRIVING_EXPERIENCE_13934'n $6;
      'I_DRIVING_EXPERIENCE_13934'n='I_DRIVING_EXPERIENCE'n;
'P_DRIVING_EXPERIENCE0_9y_13934'n='P_DRIVING_EXPERIENCE0_9y'n;
'P_DRIVING_EXPERIENCE10_1_13934'n='P_DRIVING_EXPERIENCE10_19y'n;
'P_DRIVING_EXPERIENCE20_2_13934'n='P_DRIVING_EXPERIENCE20_29y'n;
'P_DRIVING_EXPERIENCE30y__13934'n='P_DRIVING_EXPERIENCE30y_'n;
   /*------------------------------------------*/
";

run;
Quit;

/* Persist the output table */
proc casutil;
  Save casdata="&DEST_DATA" incaslib="&DEST_LIB" casout="&DEST_DATA%str(.)sashdat" outcaslib="&DEST_LIB" replace;
Quit;
