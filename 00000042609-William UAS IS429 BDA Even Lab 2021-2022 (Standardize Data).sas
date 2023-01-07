session server;

/* Start checking for existence of each input table */
exists0=doesTableExist("CASUSER(william13@student.umn.ac.id)", "CAR_INSURANCE_CLAIM2");
if exists0 == 0 then do;
  print "Table "||"CASUSER(william13@student.umn.ac.id)"||"."||"CAR_INSURANCE_CLAIM2" || " does not exist.";
  print "UserErrorCode: 100";
  exit 1;
end;
print "Input table: "||"CASUSER(william13@student.umn.ac.id)"||"."||"CAR_INSURANCE_CLAIM2"||" found.";
/* End checking for existence of each input table */


  _dp_inputTable="CAR_INSURANCE_CLAIM2";
  _dp_inputCaslib="CASUSER(william13@student.umn.ac.id)";

  _dp_outputTable="2aec1c8e-a828-4923-9642-bfad0708e354";
  _dp_outputCaslib="CASUSER(william13@student.umn.ac.id)";

dataStep.runCode result=r status=rc / code='/* BEGIN data step with the output table                                           data */
data "2aec1c8e-a828-4923-9642-bfad0708e354" (caslib="CASUSER(william13@student.umn.ac.id)" promote="no");


    /* Set the input                                                                set */
    set "CAR_INSURANCE_CLAIM2" (caslib="CASUSER(william13@student.umn.ac.id)"  );

    /* BEGIN statement 192d33e0_da9c_4744_8ec9_c78725f2bd49               dqstandardize */
    "POSTAL_CODE"n = dqstandardize ("POSTAL_CODE"n, "Postal Code", "ENUSA");
    /* END statement 192d33e0_da9c_4744_8ec9_c78725f2bd49                 dqstandardize */

    /* BEGIN statement 192d33e0_da9c_4744_8ec9_c78725f2bd49               dqstandardize */
    "GENDER"n = dqstandardize ("GENDER"n, "Address", "ENUSA");
    /* END statement 192d33e0_da9c_4744_8ec9_c78725f2bd49                 dqstandardize */

    /* BEGIN statement 192d33e0_da9c_4744_8ec9_c78725f2bd49               dqstandardize */
    "EDUCATION"n = dqstandardize ("EDUCATION"n, "Address", "ENUSA");
    /* END statement 192d33e0_da9c_4744_8ec9_c78725f2bd49                 dqstandardize */

    /* BEGIN statement 192d33e0_da9c_4744_8ec9_c78725f2bd49               dqstandardize */
    "VEHICLE_TYPE"n = dqstandardize ("VEHICLE_TYPE"n, "Address", "ENUSA");
    /* END statement 192d33e0_da9c_4744_8ec9_c78725f2bd49                 dqstandardize */

/* END data step                                                                    run */
run;
';
if rc.statusCode != 0 then do;
  print "Error executing datastep";
  exit 2;
end;
  _dp_inputTable="2aec1c8e-a828-4923-9642-bfad0708e354";
  _dp_inputCaslib="CASUSER(william13@student.umn.ac.id)";

  _dp_outputTable="CAR_INSURANCE_CLAIM2_NEW";
  _dp_outputCaslib="CASUSER(william13@student.umn.ac.id)";

srcCasTable="2aec1c8e-a828-4923-9642-bfad0708e354";
srcCasLib="CASUSER(william13@student.umn.ac.id)";
tgtCasTable="CAR_INSURANCE_CLAIM2_NEW";
tgtCasLib="CASUSER(william13@student.umn.ac.id)";
saveType="sashdat";
tgtCasTableLabel="";
replace=1;
saveToDisk=1;

exists = doesTableExist(tgtCasLib, tgtCasTable);
if (exists !=0) then do;
  if (replace == 0) then do;
    print "Table already exists and replace flag is set to false.";
    exit ({severity=2, reason=5, formatted="Table already exists and replace flag is set to false.", statusCode=9});
  end;
end;

if (saveToDisk == 1) then do;
  /* Save will automatically save as type represented by file ext */
  saveName=tgtCasTable;
  if(saveType != "") then do;
    saveName=tgtCasTable || "." || saveType;
  end;
  table.save result=r status=rc / caslib=tgtCasLib name=saveName replace=replace
    table={
      caslib=srcCasLib
      name=srcCasTable
    };
  if rc.statusCode != 0 then do;
    return rc.statusCode;
  end;
  tgtCasPath=dictionary(r, "name");

  dropTableIfExists(tgtCasLib, tgtCasTable);
  dropTableIfExists(tgtCasLib, tgtCasTable);

  table.loadtable result=r status=rc / caslib=tgtCasLib path=tgtCasPath casout={name=tgtCasTable caslib=tgtCasLib} promote=1;
  if rc.statusCode != 0 then do;
    return rc.statusCode;
  end;
end;

else do;
  dropTableIfExists(tgtCasLib, tgtCasTable);
  dropTableIfExists(tgtCasLib, tgtCasTable);
  table.promote result=r status=rc / caslib=srcCasLib name=srcCasTable target=tgtCasTable targetLib=tgtCasLib;
  if rc.statusCode != 0 then do;
    return rc.statusCode;
  end;
end;


dropTableIfExists("CASUSER(william13@student.umn.ac.id)", "2aec1c8e-a828-4923-9642-bfad0708e354");

function doesTableExist(casLib, casTable);
  table.tableExists result=r status=rc / caslib=casLib table=casTable;
  tableExists = dictionary(r, "exists");
  return tableExists;
end func;

function dropTableIfExists(casLib,casTable);
  tableExists = doesTableExist(casLib, casTable);
  if tableExists != 0 then do;
    print "Dropping table: "||casLib||"."||casTable;
    table.dropTable result=r status=rc/ caslib=casLib table=casTable quiet=0;
    if rc.statusCode != 0 then do;
      exit();
    end;
  end;
end func;

/* Return list of columns in a table */
function columnList(casLib, casTable);
  table.columnInfo result=collist / table={caslib=casLib,name=casTable};
  ndimen=dim(collist['columninfo']);
  featurelist={};
  do i =  1 to ndimen;
    featurelist[i]=upcase(collist['columninfo'][i][1]);
  end;
  return featurelist;
end func;
