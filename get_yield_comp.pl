#usr/bin/perl -w

#Written by: Wheaton Schroeder
#Latest version: 05/31/2022
#Written to automate the process of collecting and plotting yield data

use strict;
use Excel::Writer::XLSX;

#create a workbook to write the results to:
my $workbook = Excel::Writer::XLSX->new('yield_data.xlsx');
my $data_worksheet = $workbook->add_worksheet('teun_comp_data');

##################################################################################
################################ FORMATTING EXCEL ################################
##################################################################################
#build our tables

############################### biomass yield table ##############################
$data_worksheet->write('A1', 'BIOMASS');
$data_worksheet->write('A2', 'LL1004');
$data_worksheet->write('A3', 'AVM008');
$data_worksheet->write('A4', 'AVM051');
$data_worksheet->write('A5', 'AVM003');
$data_worksheet->write('A6', 'AVM059');
$data_worksheet->write('A7', 'AVM053');
$data_worksheet->write('A8', 'AVM052');
$data_worksheet->write('A9', 'AVM060');
$data_worksheet->write('A10', 'AVM056');
$data_worksheet->write('A11', 'AVM061');

#populate in vivo data
$data_worksheet->write('B1', 'mean in vivo yield (g/g)');
$data_worksheet->write('B2', '0.28198');
$data_worksheet->write('B3', '0.25839');
$data_worksheet->write('B4', '0.21434');
$data_worksheet->write('B5', '0.22438');
$data_worksheet->write('B6', '0.25853');
$data_worksheet->write('B7', '0.20716');
$data_worksheet->write('B8', '0.19025');
$data_worksheet->write('B9', '0.19845');
$data_worksheet->write('B10', '0.20727');
$data_worksheet->write('B11', '0.17627');

#populate in vivo data
$data_worksheet->write('C1', 'stdev in vivo yield (g/g)');
$data_worksheet->write('C2', '0.01401');
$data_worksheet->write('C3', '0.01256');
$data_worksheet->write('C4', '0.00610');
$data_worksheet->write('C5', '0.00567');
$data_worksheet->write('C6', '0.00618');
$data_worksheet->write('C7', '0.00548');
$data_worksheet->write('C8', '0.00774');
$data_worksheet->write('C9', '0.01467');
$data_worksheet->write('C10', '0.00365');
$data_worksheet->write('C11', '0.00396');

#get the 95% confidence interval standard deviation (e.g. 1.96 * std)
$data_worksheet->write('D1', 'CI bars (1.96 * stdev)');
$data_worksheet->write_formula('D2', '=1.96*C2');
$data_worksheet->write_formula('D3', '=1.96*C3');
$data_worksheet->write_formula('D4', '=1.96*C4');
$data_worksheet->write_formula('D5', '=1.96*C5');
$data_worksheet->write_formula('D6', '=1.96*C6');
$data_worksheet->write_formula('D7', '=1.96*C7');
$data_worksheet->write_formula('D8', '=1.96*C8');
$data_worksheet->write_formula('D9', '=1.96*C9');
$data_worksheet->write_formula('D10', '=1.96*C10');
$data_worksheet->write_formula('D11', '=1.96*C11');

#leave space for the old model data
$data_worksheet->write('E1', 'maximum yield (old model)');

#write z-scores, add formula for calculating these scores
$data_worksheet->write('F1', 'z-score (old model)');
$data_worksheet->write_formula('F2', '=(E2-B2)/C2');
$data_worksheet->write_formula('F3', '=(E3-B3)/C3');
$data_worksheet->write_formula('F4', '=(E4-B4)/C4');
$data_worksheet->write_formula('F5', '=(E5-B5)/C5');
$data_worksheet->write_formula('F6', '=(E6-B6)/C6');
$data_worksheet->write_formula('F7', '=(E7-B7)/C7');
$data_worksheet->write_formula('F8', '=(E8-B8)/C8');
$data_worksheet->write_formula('F9', '=(E9-B9)/C9');
$data_worksheet->write_formula('F10', '=(E10-B10)/C10');
$data_worksheet->write_formula('F11', '=(E11-B11)/C11');

#write error, add formula for calculating this
$data_worksheet->write('G1', 'error (old model)');
$data_worksheet->write_formula('G2', '=(E2-B2)/B2');
$data_worksheet->write_formula('G3', '=(E3-B3)/B3');
$data_worksheet->write_formula('G4', '=(E4-B4)/B4');
$data_worksheet->write_formula('G5', '=(E5-B5)/B5');
$data_worksheet->write_formula('G6', '=(E6-B6)/B6');
$data_worksheet->write_formula('G7', '=(E7-B7)/B7');
$data_worksheet->write_formula('G8', '=(E8-B8)/B8');
$data_worksheet->write_formula('G9', '=(E9-B9)/B9');
$data_worksheet->write_formula('G10', '=(E10-B10)/B10');
$data_worksheet->write_formula('G11', '=(E11-B11)/B11');

#leave space for the new model data
$data_worksheet->write('H1', 'maximum yield (new model)');

#write z-scores, add formula for calculating these scores
$data_worksheet->write('I1', 'z-score (new model)');
$data_worksheet->write_formula('I2', '=(H2-B2)/C2');
$data_worksheet->write_formula('I3', '=(H3-B3)/C3');
$data_worksheet->write_formula('I4', '=(H4-B4)/C4');
$data_worksheet->write_formula('I5', '=(H5-B5)/C5');
$data_worksheet->write_formula('I6', '=(H6-B6)/C6');
$data_worksheet->write_formula('I7', '=(H7-B7)/C7');
$data_worksheet->write_formula('I8', '=(H8-B8)/C8');
$data_worksheet->write_formula('I9', '=(H9-B9)/C9');
$data_worksheet->write_formula('I10', '=(H10-B10)/C10');
$data_worksheet->write_formula('I11', '=(H11-B11)/C11');

#write error, add formula for calculating this
$data_worksheet->write('J1', 'error (new model)');
$data_worksheet->write_formula('J2', '=(H2-B2)/B2');
$data_worksheet->write_formula('J3', '=(H3-B3)/B3');
$data_worksheet->write_formula('J4', '=(H4-B4)/B4');
$data_worksheet->write_formula('J5', '=(H5-B5)/B5');
$data_worksheet->write_formula('J6', '=(H6-B6)/B6');
$data_worksheet->write_formula('J7', '=(H7-B7)/B7');
$data_worksheet->write_formula('J8', '=(H8-B8)/B8');
$data_worksheet->write_formula('J9', '=(H9-B9)/B9');
$data_worksheet->write_formula('J10', '=(H10-B10)/B10');
$data_worksheet->write_formula('J11', '=(H11-B11)/B11');

############################### ethanol yield table ##############################
$data_worksheet->write('A13', 'ETHANOL');
$data_worksheet->write('A14', 'LL1004');
$data_worksheet->write('A15', 'AVM008');
$data_worksheet->write('A16', 'AVM051');
$data_worksheet->write('A17', 'AVM003');
$data_worksheet->write('A18', 'AVM059');
$data_worksheet->write('A19', 'AVM053');
$data_worksheet->write('A20', 'AVM052');
$data_worksheet->write('A21', 'AVM060');
$data_worksheet->write('A22', 'AVM056');
$data_worksheet->write('A23', 'AVM061');

#populate in vivo data
$data_worksheet->write('B13', 'mean in vivo yield (mol/mol)');
$data_worksheet->write('B14', '0.81067');
$data_worksheet->write('B15', '0.77221');
$data_worksheet->write('B16', '0.89255');
$data_worksheet->write('B17', '0.74902');
$data_worksheet->write('B18', '0.97154');
$data_worksheet->write('B19', '0.94992');
$data_worksheet->write('B20', '0.81480');
$data_worksheet->write('B21', '0.90584');
$data_worksheet->write('B22', '0.93805');
$data_worksheet->write('B23', '0.90042');

#populate in vivo data
$data_worksheet->write('C13', 'stdev in vivo yield (mol/mol)');
$data_worksheet->write('C14', '0.043496');
$data_worksheet->write('C15', '0.060672');
$data_worksheet->write('C16', '0.044414');
$data_worksheet->write('C17', '0.039667');
$data_worksheet->write('C18', '0.044697');
$data_worksheet->write('C19', '0.079599');
$data_worksheet->write('C20', '0.072310');
$data_worksheet->write('C21', '0.064913');
$data_worksheet->write('C22', '0.029943');
$data_worksheet->write('C23', '0.032526');

$data_worksheet->write('D13', 'CI error bars (1.96 * stdev)');
$data_worksheet->write_formula('D14', '=1.96*C14');
$data_worksheet->write_formula('D15', '=1.96*C15');
$data_worksheet->write_formula('D16', '=1.96*C16');
$data_worksheet->write_formula('D17', '=1.96*C17');
$data_worksheet->write_formula('D18', '=1.96*C18');
$data_worksheet->write_formula('D19', '=1.96*C19');
$data_worksheet->write_formula('D20', '=1.96*C20');
$data_worksheet->write_formula('D21', '=1.96*C21');
$data_worksheet->write_formula('D22', '=1.96*C22');
$data_worksheet->write_formula('D23', '=1.96*C23');

#leave space for the old model data
$data_worksheet->write('E13', 'pFBA yield (old model)');

#leave space for the old model data
$data_worksheet->write('F13', 'maximum yield (FVA, old model)');

#leave space for the old model data
$data_worksheet->write('G13', 'minimum yield (FVA, old model)');

#make calculations for the error bars
#upper error bar
$data_worksheet->write('H13', 'error bar upper (old model)');
$data_worksheet->write_formula('H14', '=F14-E14');
$data_worksheet->write_formula('H15', '=F15-E15');
$data_worksheet->write_formula('H16', '=F16-E16');
$data_worksheet->write_formula('H17', '=F17-E17');
$data_worksheet->write_formula('H18', '=F18-E18');
$data_worksheet->write_formula('H19', '=F19-E19');
$data_worksheet->write_formula('H20', '=F20-E20');
$data_worksheet->write_formula('H21', '=F21-E21');
$data_worksheet->write_formula('H22', '=F22-E22');
$data_worksheet->write_formula('H23', '=F23-E23');

#lower error bar
$data_worksheet->write('I13', 'error bar lower (old model)');
$data_worksheet->write_formula('I14', '=E14-G14');
$data_worksheet->write_formula('I15', '=E15-G15');
$data_worksheet->write_formula('I16', '=E16-G16');
$data_worksheet->write_formula('I17', '=E17-G17');
$data_worksheet->write_formula('I18', '=E18-G18');
$data_worksheet->write_formula('I19', '=E19-G19');
$data_worksheet->write_formula('I20', '=E20-G20');
$data_worksheet->write_formula('I21', '=E21-G21');
$data_worksheet->write_formula('I22', '=E22-G22');
$data_worksheet->write_formula('I23', '=E23-G23');

#look for overlap
#determine distance between minimum model and maximum 
$data_worksheet->write('J13', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write_formula('J14', '=(B14 + 1.96 * C14) - G14');
$data_worksheet->write_formula('J15', '=(B15 + 1.96 * C15) - G15');
$data_worksheet->write_formula('J16', '=(B16 + 1.96 * C16) - G16');
$data_worksheet->write_formula('J17', '=(B17 + 1.96 * C17) - G17');
$data_worksheet->write_formula('J18', '=(B18 + 1.96 * C18) - G18');
$data_worksheet->write_formula('J19', '=(B19 + 1.96 * C19) - G19');
$data_worksheet->write_formula('J20', '=(B20 + 1.96 * C20) - G20');
$data_worksheet->write_formula('J21', '=(B21 + 1.96 * C21) - G21');
$data_worksheet->write_formula('J22', '=(B22 + 1.96 * C22) - G22');
$data_worksheet->write_formula('J23', '=(B23 + 1.96 * C23) - G23');

#logic to see if max - min is a problem
$data_worksheet->write('K13', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('K14', '=IF(L14 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K15', '=IF(L15 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K16', '=IF(L16 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K17', '=IF(L17 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K18', '=IF(L18 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K19', '=IF(L19 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K20', '=IF(L20 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K21', '=IF(L21 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K22', '=IF(L22 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K23', '=IF(L23 >= 0,"OK","NON OVERLAP")');

#determine distance between minimum model and maximum 
$data_worksheet->write('L13', 'model max - in vivo min CI95 (old model)');
$data_worksheet->write_formula('L14', '=F14 - (B14 - 1.96 * C14)');
$data_worksheet->write_formula('L15', '=F15 - (B15 - 1.96 * C15)');
$data_worksheet->write_formula('L16', '=F16 - (B16 - 1.96 * C16)');
$data_worksheet->write_formula('L17', '=F17 - (B17 - 1.96 * C17)');
$data_worksheet->write_formula('L18', '=F18 - (B18 - 1.96 * C18)');
$data_worksheet->write_formula('L19', '=F19 - (B19 - 1.96 * C19)');
$data_worksheet->write_formula('L20', '=F20 - (B20 - 1.96 * C20)');
$data_worksheet->write_formula('L21', '=F21 - (B21 - 1.96 * C21)');
$data_worksheet->write_formula('L22', '=F22 - (B22 - 1.96 * C22)');
$data_worksheet->write_formula('L23', '=F23 - (B23 - 1.96 * C23)');

$data_worksheet->write('M13', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('M14', '=IF(L14 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M15', '=IF(L15 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M16', '=IF(L16 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M17', '=IF(L17 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M18', '=IF(L18 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M19', '=IF(L19 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M20', '=IF(L20 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M21', '=IF(L21 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M22', '=IF(L22 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M23', '=IF(L23 >= 0,"OK","NON OVERLAP")');

#logic to see if min - max is a problem
$data_worksheet->write('N13', 'overlap assessment (old model)');
$data_worksheet->write('N14', '=IF(COUNTIF(K14,"=OK") + COUNTIF(M14,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N15', '=IF(COUNTIF(K15,"=OK") + COUNTIF(M15,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N16', '=IF(COUNTIF(K16,"=OK") + COUNTIF(M16,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N17', '=IF(COUNTIF(K17,"=OK") + COUNTIF(M17,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N18', '=IF(COUNTIF(K18,"=OK") + COUNTIF(M18,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N19', '=IF(COUNTIF(K19,"=OK") + COUNTIF(M19,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N20', '=IF(COUNTIF(K20,"=OK") + COUNTIF(M20,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N21', '=IF(COUNTIF(K21,"=OK") + COUNTIF(M21,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N22', '=IF(COUNTIF(K22,"=OK") + COUNTIF(M22,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N23', '=IF(COUNTIF(K23,"=OK") + COUNTIF(M23,"=OK") = 2,"OK","NON OVERLAP")');

#leave space for the new model data
$data_worksheet->write('O13', 'pFBA yield (new model)');

#leave space for the new model data
$data_worksheet->write('P13', 'maximum yield (FVA, new model)');

#leave space for the new model data
$data_worksheet->write('Q13', 'minimum yield (FVA, new model)');

#make calculations for the error bars
#upper error bar
$data_worksheet->write('R13', 'error bar upper (old model)');
$data_worksheet->write_formula('R14', '=P14-O14');
$data_worksheet->write_formula('R15', '=P15-O15');
$data_worksheet->write_formula('R16', '=P16-O16');
$data_worksheet->write_formula('R17', '=P17-O17');
$data_worksheet->write_formula('R18', '=P18-O18');
$data_worksheet->write_formula('R19', '=P19-O19');
$data_worksheet->write_formula('R20', '=P20-O20');
$data_worksheet->write_formula('R21', '=P21-O21');
$data_worksheet->write_formula('R22', '=P22-O22');
$data_worksheet->write_formula('R23', '=P23-O23');

#lower error bar
$data_worksheet->write('S13', 'error bar lower (old model)');
$data_worksheet->write_formula('S14', '=O14-Q14');
$data_worksheet->write_formula('S15', '=O15-Q15');
$data_worksheet->write_formula('S16', '=O16-Q16');
$data_worksheet->write_formula('S17', '=O17-Q17');
$data_worksheet->write_formula('S18', '=O18-Q18');
$data_worksheet->write_formula('S19', '=O19-Q19');
$data_worksheet->write_formula('S20', '=O20-Q20');
$data_worksheet->write_formula('S21', '=O21-Q21');
$data_worksheet->write_formula('S22', '=O22-Q22');
$data_worksheet->write_formula('S23', '=O23-Q23');

#look for overlap
#determine distance between minimum model and maximum 
$data_worksheet->write('T13', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write_formula('T14', '=(B14 + 1.96 * C14) - Q14');
$data_worksheet->write_formula('T15', '=(B15 + 1.96 * C15) - Q15');
$data_worksheet->write_formula('T16', '=(B16 + 1.96 * C16) - Q16');
$data_worksheet->write_formula('T17', '=(B17 + 1.96 * C17) - Q17');
$data_worksheet->write_formula('T18', '=(B18 + 1.96 * C18) - Q18');
$data_worksheet->write_formula('T19', '=(B19 + 1.96 * C19) - Q19');
$data_worksheet->write_formula('T20', '=(B20 + 1.96 * C20) - Q20');
$data_worksheet->write_formula('T21', '=(B21 + 1.96 * C21) - Q21');
$data_worksheet->write_formula('T22', '=(B22 + 1.96 * C22) - Q22');
$data_worksheet->write_formula('T23', '=(B23 + 1.96 * C23) - Q23');

#logic to see if max - min is a problem
$data_worksheet->write('U13', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('U14', '=IF(T14 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U15', '=IF(T15 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U16', '=IF(T16 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U17', '=IF(T17 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U18', '=IF(T18 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U19', '=IF(T19 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U20', '=IF(T20 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U21', '=IF(T21 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U22', '=IF(T22 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U23', '=IF(T23 >= 0,"OK","NON OVERLAP")');

#determine distance between minimum model and maximum 
$data_worksheet->write('V13', 'model max - in vivo min CI95 (old model)');
$data_worksheet->write_formula('V14', '=P14 - (B14 - 1.96 * C14)');
$data_worksheet->write_formula('V15', '=P15 - (B15 - 1.96 * C15)');
$data_worksheet->write_formula('V16', '=P16 - (B16 - 1.96 * C16)');
$data_worksheet->write_formula('V17', '=P17 - (B17 - 1.96 * C17)');
$data_worksheet->write_formula('V18', '=P18 - (B18 - 1.96 * C18)');
$data_worksheet->write_formula('V19', '=P19 - (B19 - 1.96 * C19)');
$data_worksheet->write_formula('V20', '=P20 - (B20 - 1.96 * C20)');
$data_worksheet->write_formula('V21', '=P21 - (B21 - 1.96 * C21)');
$data_worksheet->write_formula('V22', '=P22 - (B22 - 1.96 * C22)');
$data_worksheet->write_formula('V23', '=P23 - (B23 - 1.96 * C23)');

$data_worksheet->write('W13', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('W14', '=IF(V14 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W15', '=IF(V15 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W16', '=IF(V16 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W17', '=IF(V17 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W18', '=IF(V18 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W19', '=IF(V19 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W20', '=IF(V20 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W21', '=IF(V21 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W22', '=IF(V22 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W23', '=IF(V23 >= 0,"OK","NON OVERLAP")');

#logic to see if min - max is a problem
$data_worksheet->write('X13', 'overlap assessment (old model)');
$data_worksheet->write('X14', '=IF(COUNTIF(W14,"=OK") + COUNTIF(U14,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X15', '=IF(COUNTIF(W15,"=OK") + COUNTIF(U15,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X16', '=IF(COUNTIF(W16,"=OK") + COUNTIF(U16,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X17', '=IF(COUNTIF(W17,"=OK") + COUNTIF(U17,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X18', '=IF(COUNTIF(W18,"=OK") + COUNTIF(U18,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X19', '=IF(COUNTIF(W19,"=OK") + COUNTIF(U19,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X20', '=IF(COUNTIF(W20,"=OK") + COUNTIF(U20,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X21', '=IF(COUNTIF(W21,"=OK") + COUNTIF(U21,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X22', '=IF(COUNTIF(W22,"=OK") + COUNTIF(U22,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X23', '=IF(COUNTIF(W23,"=OK") + COUNTIF(U23,"=OK") = 2,"OK","NON OVERLAP")');

############################### acetate yield table ##############################
$data_worksheet->write('A25', 'ACETATE');
$data_worksheet->write('A26', 'LL1004');
$data_worksheet->write('A27', 'AVM008');
$data_worksheet->write('A28', 'AVM051');
$data_worksheet->write('A29', 'AVM003');
$data_worksheet->write('A30', 'AVM059');
$data_worksheet->write('A31', 'AVM053');
$data_worksheet->write('A32', 'AVM052');
$data_worksheet->write('A33', 'AVM060');
$data_worksheet->write('A34', 'AVM056');
$data_worksheet->write('A35', 'AVM061');

#populate in vivo data
$data_worksheet->write('B25', 'mean in vivo yield (mol/mol)');
$data_worksheet->write('B26', '1.10482');
$data_worksheet->write('B27', '1.12708');
$data_worksheet->write('B28', '1.06435');
$data_worksheet->write('B29', '1.07232');
$data_worksheet->write('B30', '1.07343');
$data_worksheet->write('B31', '1.03101');
$data_worksheet->write('B32', '0.95601');
$data_worksheet->write('B33', '1.10221');
$data_worksheet->write('B34', '1.01471');
$data_worksheet->write('B35', '0.96321');

#populate in vivo data
$data_worksheet->write('C25', 'stdev in vivo yield (mol/mol)');
$data_worksheet->write('C26', '0.068369');
$data_worksheet->write('C27', '0.055310');
$data_worksheet->write('C28', '0.006630');
$data_worksheet->write('C29', '0.008758');
$data_worksheet->write('C30', '0.015122');
$data_worksheet->write('C31', '0.025425');
$data_worksheet->write('C32', '0.001178');
$data_worksheet->write('C33', '0.066558');
$data_worksheet->write('C34', '0.009886');
$data_worksheet->write('C35', '0.027293');

$data_worksheet->write('D25', 'CI error bars (1.96 * stdev)');
$data_worksheet->write_formula('D26', '=1.96*C26');
$data_worksheet->write_formula('D27', '=1.96*C27');
$data_worksheet->write_formula('D28', '=1.96*C28');
$data_worksheet->write_formula('D29', '=1.96*C29');
$data_worksheet->write_formula('D30', '=1.96*C30');
$data_worksheet->write_formula('D31', '=1.96*C31');
$data_worksheet->write_formula('D32', '=1.96*C32');
$data_worksheet->write_formula('D33', '=1.96*C33');
$data_worksheet->write_formula('D34', '=1.96*C34');
$data_worksheet->write_formula('D35', '=1.96*C35');

#leave space for the old model data
$data_worksheet->write('E25', 'pFBA yield (old model)');

#leave space for the old model data
$data_worksheet->write('F25', 'maximum yield (FVA, old model)');

#leave space for the old model data
$data_worksheet->write('G25', 'minimum yield (FVA, old model)');

#make calculations for the error bars
#upper error bar
$data_worksheet->write('H25', 'error bar upper (old model)');
$data_worksheet->write_formula('H26', '=F26-E26');
$data_worksheet->write_formula('H27', '=F27-E27');
$data_worksheet->write_formula('H28', '=F28-E28');
$data_worksheet->write_formula('H29', '=F29-E29');
$data_worksheet->write_formula('H30', '=F30-E30');
$data_worksheet->write_formula('H31', '=F31-E31');
$data_worksheet->write_formula('H32', '=F32-E32');
$data_worksheet->write_formula('H33', '=F33-E33');
$data_worksheet->write_formula('H34', '=F34-E34');
$data_worksheet->write_formula('H35', '=F35-E35');

#lower error bar
$data_worksheet->write('I25', 'error bar upper (old model)');
$data_worksheet->write_formula('I26', '=E26-G26');
$data_worksheet->write_formula('I27', '=E27-G27');
$data_worksheet->write_formula('I28', '=E28-G28');
$data_worksheet->write_formula('I29', '=E29-G29');
$data_worksheet->write_formula('I30', '=E30-G30');
$data_worksheet->write_formula('I31', '=E31-G31');
$data_worksheet->write_formula('I32', '=E32-G32');
$data_worksheet->write_formula('I33', '=E33-G33');
$data_worksheet->write_formula('I34', '=E34-G34');
$data_worksheet->write_formula('I35', '=E35-G35');

#look for overlap
#determine distance between minimum model and maximum 
$data_worksheet->write('J25', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write_formula('J26', '=(B26 + 1.96 * C26) - G26');
$data_worksheet->write_formula('J27', '=(B27 + 1.96 * C27) - G27');
$data_worksheet->write_formula('J28', '=(B28 + 1.96 * C28) - G28');
$data_worksheet->write_formula('J29', '=(B29 + 1.96 * C29) - G29');
$data_worksheet->write_formula('J30', '=(B30 + 1.96 * C30) - G30');
$data_worksheet->write_formula('J31', '=(B31 + 1.96 * C31) - G31');
$data_worksheet->write_formula('J32', '=(B32 + 1.96 * C32) - G32');
$data_worksheet->write_formula('J33', '=(B33 + 1.96 * C33) - G33');
$data_worksheet->write_formula('J34', '=(B34 + 1.96 * C34) - G34');
$data_worksheet->write_formula('J35', '=(B35 + 1.96 * C35) - G35');

#logic to see if max - min is a problem
$data_worksheet->write('K25', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('K26', '=IF(L26 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K27', '=IF(L27 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K28', '=IF(L28 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K29', '=IF(L29 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K30', '=IF(L30 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K31', '=IF(L31 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K32', '=IF(L32 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K33', '=IF(L33 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K34', '=IF(L34 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K35', '=IF(L35 >= 0,"OK","NON OVERLAP")');

#determine distance between minimum model and maximum 
$data_worksheet->write('L25', 'model max - in vivo min CI95 (old model)');
$data_worksheet->write_formula('L26', '=F26 - (B26 - 1.96 * C26)');
$data_worksheet->write_formula('L27', '=F27 - (B27 - 1.96 * C27)');
$data_worksheet->write_formula('L28', '=F28 - (B28 - 1.96 * C28)');
$data_worksheet->write_formula('L29', '=F29 - (B29 - 1.96 * C29)');
$data_worksheet->write_formula('L30', '=F30 - (B30 - 1.96 * C30)');
$data_worksheet->write_formula('L31', '=F31 - (B31 - 1.96 * C31)');
$data_worksheet->write_formula('L32', '=F32 - (B32 - 1.96 * C32)');
$data_worksheet->write_formula('L33', '=F33 - (B33 - 1.96 * C33)');
$data_worksheet->write_formula('L34', '=F34 - (B34 - 1.96 * C34)');
$data_worksheet->write_formula('L35', '=F35 - (B35 - 1.96 * C35)');

$data_worksheet->write('M25', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('M26', '=IF(L26 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M27', '=IF(L27 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M28', '=IF(L28 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M29', '=IF(L29 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M30', '=IF(L30 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M31', '=IF(L31 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M32', '=IF(L32 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M33', '=IF(L33 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M34', '=IF(L34 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M35', '=IF(L35 >= 0,"OK","NON OVERLAP")');

#logic to see if min - max is a problem
$data_worksheet->write('N25', 'overlap assessment (old model)');
$data_worksheet->write('N26', '=IF(COUNTIF(K26,"=OK") + COUNTIF(M26,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N27', '=IF(COUNTIF(K27,"=OK") + COUNTIF(M27,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N28', '=IF(COUNTIF(K28,"=OK") + COUNTIF(M28,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N29', '=IF(COUNTIF(K29,"=OK") + COUNTIF(M29,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N30', '=IF(COUNTIF(K30,"=OK") + COUNTIF(M30,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N31', '=IF(COUNTIF(K31,"=OK") + COUNTIF(M31,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N32', '=IF(COUNTIF(K32,"=OK") + COUNTIF(M32,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N33', '=IF(COUNTIF(K33,"=OK") + COUNTIF(M33,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N34', '=IF(COUNTIF(K34,"=OK") + COUNTIF(M34,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N35', '=IF(COUNTIF(K35,"=OK") + COUNTIF(M35,"=OK") = 2,"OK","NON OVERLAP")');

#leave space for the new model data
$data_worksheet->write('O25', 'pFBA yield (new model)');

#leave space for the new model data
$data_worksheet->write('P25', 'maximum yield (FVA, new model)');

#leave space for the new model data
$data_worksheet->write('Q25', 'minimum yield (FVA, new model)');

#make calculations for the error bars
#upper error bar
$data_worksheet->write('R25', 'error bar upper (old model)');
$data_worksheet->write_formula('R26', '=P26-O26');
$data_worksheet->write_formula('R27', '=P27-O27');
$data_worksheet->write_formula('R28', '=P28-O28');
$data_worksheet->write_formula('R29', '=P29-O29');
$data_worksheet->write_formula('R30', '=P30-O30');
$data_worksheet->write_formula('R31', '=P31-O31');
$data_worksheet->write_formula('R32', '=P32-O32');
$data_worksheet->write_formula('R33', '=P33-O33');
$data_worksheet->write_formula('R34', '=P34-O34');
$data_worksheet->write_formula('R35', '=P35-O35');

#lower error bar
$data_worksheet->write('S25', 'error bar lower (old model)');
$data_worksheet->write_formula('S26', '=O26-Q26');
$data_worksheet->write_formula('S27', '=O27-Q27');
$data_worksheet->write_formula('S28', '=O28-Q28');
$data_worksheet->write_formula('S29', '=O29-Q29');
$data_worksheet->write_formula('S30', '=O30-Q30');
$data_worksheet->write_formula('S31', '=O31-Q31');
$data_worksheet->write_formula('S32', '=O32-Q32');
$data_worksheet->write_formula('S33', '=O33-Q33');
$data_worksheet->write_formula('S34', '=O34-Q34');
$data_worksheet->write_formula('S35', '=O35-Q35');

#look for overlap
#determine distance between minimum model and maximum 
$data_worksheet->write('T25', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write_formula('T26', '=(B26 + 1.96 * C26) - Q26');
$data_worksheet->write_formula('T27', '=(B27 + 1.96 * C27) - Q27');
$data_worksheet->write_formula('T28', '=(B28 + 1.96 * C28) - Q28');
$data_worksheet->write_formula('T29', '=(B29 + 1.96 * C29) - Q29');
$data_worksheet->write_formula('T30', '=(B30 + 1.96 * C30) - Q30');
$data_worksheet->write_formula('T31', '=(B31 + 1.96 * C31) - Q31');
$data_worksheet->write_formula('T32', '=(B32 + 1.96 * C32) - Q32');
$data_worksheet->write_formula('T33', '=(B33 + 1.96 * C33) - Q33');
$data_worksheet->write_formula('T34', '=(B34 + 1.96 * C34) - Q34');
$data_worksheet->write_formula('T35', '=(B35 + 1.96 * C35) - Q35');

#logic to see if max - min is a problem
$data_worksheet->write('U25', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('U26', '=IF(T26 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U27', '=IF(T27 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U28', '=IF(T28 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U29', '=IF(T29 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U30', '=IF(T30 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U31', '=IF(T31 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U32', '=IF(T32 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U33', '=IF(T33 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U34', '=IF(T34 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U35', '=IF(T35 >= 0,"OK","NON OVERLAP")');

#determine distance between minimum model and maximum 
$data_worksheet->write('V25', 'model max - in vivo min CI95 (old model)');
$data_worksheet->write_formula('V26', '=P26 - (B26 - 1.96 * C26)');
$data_worksheet->write_formula('V27', '=P27 - (B27 - 1.96 * C27)');
$data_worksheet->write_formula('V28', '=P28 - (B28 - 1.96 * C28)');
$data_worksheet->write_formula('V29', '=P29 - (B29 - 1.96 * C29)');
$data_worksheet->write_formula('V30', '=P30 - (B30 - 1.96 * C30)');
$data_worksheet->write_formula('V31', '=P31 - (B31 - 1.96 * C31)');
$data_worksheet->write_formula('V32', '=P32 - (B32 - 1.96 * C32)');
$data_worksheet->write_formula('V33', '=P33 - (B33 - 1.96 * C33)');
$data_worksheet->write_formula('V34', '=P34 - (B34 - 1.96 * C34)');
$data_worksheet->write_formula('V35', '=P35 - (B35 - 1.96 * C35)');

$data_worksheet->write('W25', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('W26', '=IF(V26 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W27', '=IF(V27 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W28', '=IF(V28 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W29', '=IF(V29 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W30', '=IF(V30 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W31', '=IF(V31 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W32', '=IF(V32 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W33', '=IF(V33 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W34', '=IF(V34 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W35', '=IF(V35 >= 0,"OK","NON OVERLAP")');

#logic to see if min - max is a problem
$data_worksheet->write('X25', 'overlap assessment (old model)');
$data_worksheet->write('X26', '=IF(COUNTIF(W26,"=OK") + COUNTIF(U26,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X27', '=IF(COUNTIF(W27,"=OK") + COUNTIF(U27,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X28', '=IF(COUNTIF(W28,"=OK") + COUNTIF(U28,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X29', '=IF(COUNTIF(W29,"=OK") + COUNTIF(U29,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X30', '=IF(COUNTIF(W30,"=OK") + COUNTIF(U30,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X31', '=IF(COUNTIF(W31,"=OK") + COUNTIF(U31,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X32', '=IF(COUNTIF(W32,"=OK") + COUNTIF(U32,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X33', '=IF(COUNTIF(W33,"=OK") + COUNTIF(U33,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X34', '=IF(COUNTIF(W34,"=OK") + COUNTIF(U34,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X35', '=IF(COUNTIF(W35,"=OK") + COUNTIF(U35,"=OK") = 2,"OK","NON OVERLAP")');

############################### formate yield table ##############################
$data_worksheet->write('A37', 'FORMATE');
$data_worksheet->write('A38', 'LL1004');
$data_worksheet->write('A39', 'AVM008');
$data_worksheet->write('A40', 'AVM051');
$data_worksheet->write('A41', 'AVM003');
$data_worksheet->write('A42', 'AVM059');
$data_worksheet->write('A43', 'AVM053');
$data_worksheet->write('A44', 'AVM052');
$data_worksheet->write('A45', 'AVM060');
$data_worksheet->write('A46', 'AVM056');
$data_worksheet->write('A47', 'AVM061');

#populate in vivo data
$data_worksheet->write('B37', 'mean in vivo yield (mol/mol)');
$data_worksheet->write('B38', '0.31535');
$data_worksheet->write('B39', '0.24595');
$data_worksheet->write('B40', '0.28369');
$data_worksheet->write('B41', '0.35384');
$data_worksheet->write('B42', '0.26464');
$data_worksheet->write('B43', '0.23120');
$data_worksheet->write('B44', '0.28417');
$data_worksheet->write('B45', '0.26005');
$data_worksheet->write('B46', '0.25284');
$data_worksheet->write('B47', '0.15166');

#populate in vivo data
$data_worksheet->write('C37', 'stdev in vivo yield (mol/mol)');
$data_worksheet->write('C38', '0.020999');
$data_worksheet->write('C39', '0.049992');
$data_worksheet->write('C40', '0.005992');
$data_worksheet->write('C41', '0.021409');
$data_worksheet->write('C42', '0.007084');
$data_worksheet->write('C43', '0.037311');
$data_worksheet->write('C44', '0.005635');
$data_worksheet->write('C45', '0.064688');
$data_worksheet->write('C46', '0.009393');
$data_worksheet->write('C47', '0.002363');

$data_worksheet->write('D37', 'CI error bars (1.96 * stdev)');
$data_worksheet->write_formula('D38', '=1.96*C38');
$data_worksheet->write_formula('D39', '=1.96*C39');
$data_worksheet->write_formula('D40', '=1.96*C40');
$data_worksheet->write_formula('D41', '=1.96*C41');
$data_worksheet->write_formula('D42', '=1.96*C42');
$data_worksheet->write_formula('D43', '=1.96*C43');
$data_worksheet->write_formula('D44', '=1.96*C44');
$data_worksheet->write_formula('D45', '=1.96*C45');
$data_worksheet->write_formula('D46', '=1.96*C46');
$data_worksheet->write_formula('D47', '=1.96*C47');

#leave space for the old model data
$data_worksheet->write('E37', 'pFBA yield (old model)');

#leave space for the old model data
$data_worksheet->write('F37', 'maximum yield (FVA, old model)');

#leave space for the old model data
$data_worksheet->write('G37', 'minimum yield (FVA, old model)');

#make calculations for the error bars
#upper error bar
$data_worksheet->write('H37', 'error bar upper (old model)');
$data_worksheet->write_formula('H38', '=F38-E38');
$data_worksheet->write_formula('H39', '=F39-E39');
$data_worksheet->write_formula('H40', '=F40-E40');
$data_worksheet->write_formula('H41', '=F41-E41');
$data_worksheet->write_formula('H42', '=F42-E42');
$data_worksheet->write_formula('H43', '=F43-E43');
$data_worksheet->write_formula('H44', '=F44-E44');
$data_worksheet->write_formula('H45', '=F45-E45');
$data_worksheet->write_formula('H46', '=F46-E46');
$data_worksheet->write_formula('H47', '=F47-E47');

#lower error bar
$data_worksheet->write('I37', 'error bar lower (old model)');
$data_worksheet->write_formula('I38', '=E38-G38');
$data_worksheet->write_formula('I39', '=E39-G39');
$data_worksheet->write_formula('I40', '=E40-G40');
$data_worksheet->write_formula('I41', '=E41-G41');
$data_worksheet->write_formula('I42', '=E42-G42');
$data_worksheet->write_formula('I43', '=E43-G43');
$data_worksheet->write_formula('I44', '=E44-G44');
$data_worksheet->write_formula('I45', '=E45-G45');
$data_worksheet->write_formula('I46', '=E46-G46');
$data_worksheet->write_formula('I47', '=E47-G47');

#look for overlap
#determine distance between minimum model and maximum 
$data_worksheet->write('J37', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write_formula('J38', '=(B38 + 1.96 * C38) - G38');
$data_worksheet->write_formula('J39', '=(B39 + 1.96 * C39) - G39');
$data_worksheet->write_formula('J40', '=(B40 + 1.96 * C40) - G40');
$data_worksheet->write_formula('J41', '=(B41 + 1.96 * C41) - G41');
$data_worksheet->write_formula('J42', '=(B42 + 1.96 * C42) - G42');
$data_worksheet->write_formula('J43', '=(B43 + 1.96 * C43) - G43');
$data_worksheet->write_formula('J44', '=(B44 + 1.96 * C44) - G44');
$data_worksheet->write_formula('J45', '=(B45 + 1.96 * C45) - G45');
$data_worksheet->write_formula('J46', '=(B46 + 1.96 * C46) - G46');
$data_worksheet->write_formula('J47', '=(B47 + 1.96 * C47) - G47');

#logic to see if max - min is a problem
$data_worksheet->write('K37', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('K38', '=IF(L38 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K39', '=IF(L39 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K40', '=IF(L40 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K41', '=IF(L41 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K42', '=IF(L42 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K43', '=IF(L43 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K44', '=IF(L44 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K45', '=IF(L45 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K46', '=IF(L46 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K47', '=IF(L47 >= 0,"OK","NON OVERLAP")');

#determine distance between minimum model and maximum 
$data_worksheet->write('L37', 'model max - in vivo min CI95 (old model)');
$data_worksheet->write_formula('L38', '=F38 - (B38 - 1.96 * C38)');
$data_worksheet->write_formula('L39', '=F39 - (B39 - 1.96 * C39)');
$data_worksheet->write_formula('L40', '=F40 - (B40 - 1.96 * C40)');
$data_worksheet->write_formula('L41', '=F41 - (B41 - 1.96 * C41)');
$data_worksheet->write_formula('L42', '=F42 - (B42 - 1.96 * C42)');
$data_worksheet->write_formula('L43', '=F43 - (B43 - 1.96 * C43)');
$data_worksheet->write_formula('L44', '=F44 - (B44 - 1.96 * C44)');
$data_worksheet->write_formula('L45', '=F45 - (B45 - 1.96 * C45)');
$data_worksheet->write_formula('L46', '=F46 - (B46 - 1.96 * C46)');
$data_worksheet->write_formula('L47', '=F47 - (B47 - 1.96 * C47)');

$data_worksheet->write('M37', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('M38', '=IF(L38 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M39', '=IF(L39 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M40', '=IF(L40 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M41', '=IF(L41 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M42', '=IF(L42 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M43', '=IF(L43 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M44', '=IF(L44 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M45', '=IF(L45 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M46', '=IF(L46 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M47', '=IF(L47 >= 0,"OK","NON OVERLAP")');

#logic to see if min - max is a problem
$data_worksheet->write('N37', 'overlap assessment (old model)');
$data_worksheet->write('N38', '=IF(COUNTIF(K38,"=OK") + COUNTIF(M38,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N39', '=IF(COUNTIF(K39,"=OK") + COUNTIF(M39,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N40', '=IF(COUNTIF(K40,"=OK") + COUNTIF(M40,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N41', '=IF(COUNTIF(K41,"=OK") + COUNTIF(M41,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N42', '=IF(COUNTIF(K42,"=OK") + COUNTIF(M42,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N43', '=IF(COUNTIF(K43,"=OK") + COUNTIF(M43,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N44', '=IF(COUNTIF(K44,"=OK") + COUNTIF(M44,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N45', '=IF(COUNTIF(K45,"=OK") + COUNTIF(M45,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N46', '=IF(COUNTIF(K46,"=OK") + COUNTIF(M46,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N47', '=IF(COUNTIF(K47,"=OK") + COUNTIF(M47,"=OK") = 2,"OK","NON OVERLAP")');

#leave space for the new model data
$data_worksheet->write('O37', 'pFBA yield (new model)');

#leave space for the new model data
$data_worksheet->write('P37', 'maximum yield (FVA, new model)');

#leave space for the new model data
$data_worksheet->write('Q37', 'minimum yield (FVA, new model)');

#make calculations for the error bars
#upper error bar
$data_worksheet->write('R37', 'error bar upper (old model)');
$data_worksheet->write_formula('R38', '=P38-O38');
$data_worksheet->write_formula('R39', '=P39-O39');
$data_worksheet->write_formula('R40', '=P40-O40');
$data_worksheet->write_formula('R41', '=P41-O41');
$data_worksheet->write_formula('R42', '=P42-O42');
$data_worksheet->write_formula('R43', '=P43-O43');
$data_worksheet->write_formula('R44', '=P44-O44');
$data_worksheet->write_formula('R45', '=P45-O45');
$data_worksheet->write_formula('R46', '=P46-O46');
$data_worksheet->write_formula('R47', '=P47-O47');

#lower error bar
$data_worksheet->write('S37', 'error bar lower (old model)');
$data_worksheet->write_formula('S38', '=O38-Q38');
$data_worksheet->write_formula('S39', '=O39-Q39');
$data_worksheet->write_formula('S40', '=O40-Q40');
$data_worksheet->write_formula('S41', '=O41-Q41');
$data_worksheet->write_formula('S42', '=O42-Q42');
$data_worksheet->write_formula('S43', '=O43-Q43');
$data_worksheet->write_formula('S44', '=O44-Q44');
$data_worksheet->write_formula('S45', '=O45-Q45');
$data_worksheet->write_formula('S46', '=O46-Q46');
$data_worksheet->write_formula('S47', '=O47-Q47');

#look for overlap
#determine distance between minimum model and maximum 
$data_worksheet->write('T37', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write_formula('T38', '=(B38 + 1.96 * C38) - Q38');
$data_worksheet->write_formula('T39', '=(B39 + 1.96 * C39) - Q39');
$data_worksheet->write_formula('T40', '=(B40 + 1.96 * C40) - Q40');
$data_worksheet->write_formula('T41', '=(B41 + 1.96 * C41) - Q41');
$data_worksheet->write_formula('T42', '=(B42 + 1.96 * C42) - Q42');
$data_worksheet->write_formula('T43', '=(B43 + 1.96 * C43) - Q43');
$data_worksheet->write_formula('T44', '=(B44 + 1.96 * C44) - Q44');
$data_worksheet->write_formula('T45', '=(B45 + 1.96 * C45) - Q45');
$data_worksheet->write_formula('T46', '=(B46 + 1.96 * C46) - Q46');
$data_worksheet->write_formula('T47', '=(B47 + 1.96 * C47) - Q47');

#logic to see if max - min is a problem
$data_worksheet->write('U37', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('U38', '=IF(T38 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U39', '=IF(T39 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U40', '=IF(T40 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U41', '=IF(T41 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U42', '=IF(T42 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U43', '=IF(T43 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U44', '=IF(T44 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U45', '=IF(T45 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U46', '=IF(T46 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U47', '=IF(T47 >= 0,"OK","NON OVERLAP")');

#determine distance between minimum model and maximum 
$data_worksheet->write('V37', 'model max - in vivo min CI95 (old model)');
$data_worksheet->write_formula('V38', '=P38 - (B38 - 1.96 * C38)');
$data_worksheet->write_formula('V39', '=P39 - (B39 - 1.96 * C39)');
$data_worksheet->write_formula('V40', '=P40 - (B40 - 1.96 * C40)');
$data_worksheet->write_formula('V41', '=P41 - (B41 - 1.96 * C41)');
$data_worksheet->write_formula('V42', '=P42 - (B42 - 1.96 * C42)');
$data_worksheet->write_formula('V43', '=P43 - (B43 - 1.96 * C43)');
$data_worksheet->write_formula('V44', '=P44 - (B44 - 1.96 * C44)');
$data_worksheet->write_formula('V45', '=P45 - (B45 - 1.96 * C45)');
$data_worksheet->write_formula('V46', '=P46 - (B46 - 1.96 * C46)');
$data_worksheet->write_formula('V47', '=P47 - (B47 - 1.96 * C47)');

$data_worksheet->write('W37', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('W38', '=IF(V38 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W39', '=IF(V39 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W40', '=IF(V40 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W41', '=IF(V41 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W42', '=IF(V42 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W43', '=IF(V43 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W44', '=IF(V44 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W45', '=IF(V45 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W46', '=IF(V46 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W47', '=IF(V47 >= 0,"OK","NON OVERLAP")');

#logic to see if min - max is a problem
$data_worksheet->write('X37', 'overlap assessment (old model)');
$data_worksheet->write('X38', '=IF(COUNTIF(W38,"=OK") + COUNTIF(U38,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X39', '=IF(COUNTIF(W39,"=OK") + COUNTIF(U39,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X40', '=IF(COUNTIF(W40,"=OK") + COUNTIF(U40,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X41', '=IF(COUNTIF(W41,"=OK") + COUNTIF(U41,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X42', '=IF(COUNTIF(W42,"=OK") + COUNTIF(U42,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X43', '=IF(COUNTIF(W43,"=OK") + COUNTIF(U43,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X44', '=IF(COUNTIF(W44,"=OK") + COUNTIF(U44,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X45', '=IF(COUNTIF(W45,"=OK") + COUNTIF(U45,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X46', '=IF(COUNTIF(W46,"=OK") + COUNTIF(U46,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X47', '=IF(COUNTIF(W47,"=OK") + COUNTIF(U47,"=OK") = 2,"OK","NON OVERLAP")');

############################### lactate yield table ##############################
$data_worksheet->write('A49', 'LACTATE');
$data_worksheet->write('A50', 'LL1004');
$data_worksheet->write('A51', 'AVM008');
$data_worksheet->write('A52', 'AVM051');
$data_worksheet->write('A53', 'AVM003');
$data_worksheet->write('A54', 'AVM059');
$data_worksheet->write('A55', 'AVM053');
$data_worksheet->write('A56', 'AVM052');
$data_worksheet->write('A57', 'AVM060');
$data_worksheet->write('A58', 'AVM056');
$data_worksheet->write('A59', 'AVM061');

#populate in vivo data
$data_worksheet->write('B49', 'mean in vivo yield (mol/mol)');
$data_worksheet->write('B50', '0.08267');
$data_worksheet->write('B51', '0.11476');
$data_worksheet->write('B52', '0.12514');
$data_worksheet->write('B53', '0.06141');
$data_worksheet->write('B54', '0.16352');
$data_worksheet->write('B55', '0.15572');
$data_worksheet->write('B56', '0.25392');
$data_worksheet->write('B57', '0.12708');
$data_worksheet->write('B58', '0.13431');
$data_worksheet->write('B59', '0.12781');

#populate in vivo data
$data_worksheet->write('C49', 'stdev in vivo yield (mol/mol)');
$data_worksheet->write('C50', '0.008316');
$data_worksheet->write('C51', '0.009662');
$data_worksheet->write('C52', '0.004953');
$data_worksheet->write('C53', '0.005425');
$data_worksheet->write('C54', '0.002362');
$data_worksheet->write('C55', '0.010000');
$data_worksheet->write('C56', '0.008057');
$data_worksheet->write('C57', '0.015623');
$data_worksheet->write('C58', '0.002274');
$data_worksheet->write('C59', '0.008571');

$data_worksheet->write('D49', 'CI error bars (1.96 * stdev)');
$data_worksheet->write_formula('D50', '=1.96*C50');
$data_worksheet->write_formula('D51', '=1.96*C51');
$data_worksheet->write_formula('D52', '=1.96*C52');
$data_worksheet->write_formula('D53', '=1.96*C53');
$data_worksheet->write_formula('D54', '=1.96*C54');
$data_worksheet->write_formula('D55', '=1.96*C55');
$data_worksheet->write_formula('D56', '=1.96*C56');
$data_worksheet->write_formula('D57', '=1.96*C57');
$data_worksheet->write_formula('D58', '=1.96*C58');
$data_worksheet->write_formula('D59', '=1.96*C59');

#leave space for the old model data
$data_worksheet->write('E49', 'pFBA yield (old model)');

#leave space for the old model data
$data_worksheet->write('F49', 'maximum yield (FVA, old model)');

#leave space for the old model data
$data_worksheet->write('G49', 'minimum yield (FVA, old model)');

#make calculations for the error bars
#upper error bar
$data_worksheet->write('H49', 'error bar upper (old model)');
$data_worksheet->write_formula('H50', '=F50-E50');
$data_worksheet->write_formula('H51', '=F51-E51');
$data_worksheet->write_formula('H52', '=F52-E52');
$data_worksheet->write_formula('H53', '=F53-E53');
$data_worksheet->write_formula('H54', '=F54-E54');
$data_worksheet->write_formula('H55', '=F55-E55');
$data_worksheet->write_formula('H56', '=F56-E56');
$data_worksheet->write_formula('H57', '=F57-E57');
$data_worksheet->write_formula('H58', '=F58-E58');
$data_worksheet->write_formula('H59', '=F59-E59');

#lower error bar
$data_worksheet->write('I49', 'error bar lower (old model)');
$data_worksheet->write_formula('I50', '=E50-G50');
$data_worksheet->write_formula('I51', '=E51-G51');
$data_worksheet->write_formula('I52', '=E52-G52');
$data_worksheet->write_formula('I53', '=E53-G53');
$data_worksheet->write_formula('I54', '=E54-G54');
$data_worksheet->write_formula('I55', '=E55-G55');
$data_worksheet->write_formula('I56', '=E56-G56');
$data_worksheet->write_formula('I57', '=E57-G57');
$data_worksheet->write_formula('I58', '=E58-G58');
$data_worksheet->write_formula('I59', '=E59-G59');

#look for overlap
#determine distance between minimum model and maximum 
$data_worksheet->write('J49', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write_formula('J50', '=(B50 + 1.96 * C50) - G50');
$data_worksheet->write_formula('J51', '=(B51 + 1.96 * C51) - G51');
$data_worksheet->write_formula('J52', '=(B52 + 1.96 * C52) - G52');
$data_worksheet->write_formula('J53', '=(B53 + 1.96 * C53) - G53');
$data_worksheet->write_formula('J54', '=(B54 + 1.96 * C54) - G54');
$data_worksheet->write_formula('J55', '=(B55 + 1.96 * C55) - G55');
$data_worksheet->write_formula('J56', '=(B56 + 1.96 * C56) - G56');
$data_worksheet->write_formula('J57', '=(B57 + 1.96 * C57) - G57');
$data_worksheet->write_formula('J58', '=(B58 + 1.96 * C58) - G58');
$data_worksheet->write_formula('J59', '=(B59 + 1.96 * C59) - G59');

#logic to see if max - min is a problem
$data_worksheet->write('K49', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('K50', '=IF(L50 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K51', '=IF(L51 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K52', '=IF(L52 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K53', '=IF(L53 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K54', '=IF(L54 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K55', '=IF(L55 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K56', '=IF(L56 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K57', '=IF(L57 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K58', '=IF(L58 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K59', '=IF(L59 >= 0,"OK","NON OVERLAP")');

#determine distance between minimum model and maximum 
$data_worksheet->write('L49', 'model max - in vivo min CI95 (old model)');
$data_worksheet->write_formula('L50', '=F50 - (B50 - 1.96 * C50)');
$data_worksheet->write_formula('L51', '=F51 - (B51 - 1.96 * C51)');
$data_worksheet->write_formula('L52', '=F52 - (B52 - 1.96 * C52)');
$data_worksheet->write_formula('L53', '=F53 - (B53 - 1.96 * C53)');
$data_worksheet->write_formula('L54', '=F54 - (B54 - 1.96 * C54)');
$data_worksheet->write_formula('L55', '=F55 - (B55 - 1.96 * C55)');
$data_worksheet->write_formula('L56', '=F56 - (B56 - 1.96 * C56)');
$data_worksheet->write_formula('L57', '=F57 - (B57 - 1.96 * C57)');
$data_worksheet->write_formula('L58', '=F58 - (B58 - 1.96 * C58)');
$data_worksheet->write_formula('L59', '=F59 - (B59 - 1.96 * C59)');

$data_worksheet->write('M49', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('M50', '=IF(L50 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M51', '=IF(L51 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M52', '=IF(L52 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M53', '=IF(L53 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M54', '=IF(L54 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M55', '=IF(L55 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M56', '=IF(L56 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M57', '=IF(L57 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M58', '=IF(L58 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M59', '=IF(L59 >= 0,"OK","NON OVERLAP")');

#logic to see if min - max is a problem
$data_worksheet->write('N49', 'overlap assessment (old model)');
$data_worksheet->write('N50', '=IF(COUNTIF(K50,"=OK") + COUNTIF(M50,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N51', '=IF(COUNTIF(K51,"=OK") + COUNTIF(M51,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N52', '=IF(COUNTIF(K52,"=OK") + COUNTIF(M52,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N53', '=IF(COUNTIF(K53,"=OK") + COUNTIF(M53,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N54', '=IF(COUNTIF(K54,"=OK") + COUNTIF(M54,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N55', '=IF(COUNTIF(K55,"=OK") + COUNTIF(M55,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N56', '=IF(COUNTIF(K56,"=OK") + COUNTIF(M56,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N57', '=IF(COUNTIF(K57,"=OK") + COUNTIF(M57,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N58', '=IF(COUNTIF(K58,"=OK") + COUNTIF(M58,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N59', '=IF(COUNTIF(K59,"=OK") + COUNTIF(M59,"=OK") = 2,"OK","NON OVERLAP")');

#leave space for the new model data
$data_worksheet->write('O49', 'pFBA yield (new model)');

#leave space for the new model data
$data_worksheet->write('P49', 'maximum yield (FVA, new model)');

#leave space for the new model data
$data_worksheet->write('Q49', 'minimum yield (FVA, new model)');

#make calculations for the error bars
#upper error bar
$data_worksheet->write('R49', 'error bar upper (old model)');
$data_worksheet->write_formula('R50', '=P50-O50');
$data_worksheet->write_formula('R51', '=P51-O51');
$data_worksheet->write_formula('R52', '=P52-O52');
$data_worksheet->write_formula('R53', '=P53-O53');
$data_worksheet->write_formula('R54', '=P54-O54');
$data_worksheet->write_formula('R55', '=P55-O55');
$data_worksheet->write_formula('R56', '=P56-O56');
$data_worksheet->write_formula('R57', '=P57-O57');
$data_worksheet->write_formula('R58', '=P58-O58');
$data_worksheet->write_formula('R59', '=P59-O59');

#lower error bar
$data_worksheet->write('S49', 'error bar lower (old model)');
$data_worksheet->write_formula('S50', '=O50-Q50');
$data_worksheet->write_formula('S51', '=O51-Q51');
$data_worksheet->write_formula('S52', '=O52-Q52');
$data_worksheet->write_formula('S53', '=O53-Q53');
$data_worksheet->write_formula('S54', '=O54-Q54');
$data_worksheet->write_formula('S55', '=O55-Q55');
$data_worksheet->write_formula('S56', '=O56-Q56');
$data_worksheet->write_formula('S57', '=O57-Q57');
$data_worksheet->write_formula('S58', '=O58-Q58');
$data_worksheet->write_formula('S59', '=O59-Q59');

#look for overlap
#determine distance between minimum model and maximum 
$data_worksheet->write('T49', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write_formula('T50', '=(B50 + 1.96 * C50) - Q50');
$data_worksheet->write_formula('T51', '=(B51 + 1.96 * C51) - Q51');
$data_worksheet->write_formula('T52', '=(B52 + 1.96 * C52) - Q52');
$data_worksheet->write_formula('T53', '=(B53 + 1.96 * C53) - Q53');
$data_worksheet->write_formula('T54', '=(B54 + 1.96 * C54) - Q54');
$data_worksheet->write_formula('T55', '=(B55 + 1.96 * C55) - Q55');
$data_worksheet->write_formula('T56', '=(B56 + 1.96 * C56) - Q56');
$data_worksheet->write_formula('T57', '=(B57 + 1.96 * C57) - Q57');
$data_worksheet->write_formula('T58', '=(B58 + 1.96 * C58) - Q58');
$data_worksheet->write_formula('T59', '=(B59 + 1.96 * C59) - Q59');

#logic to see if max - min is a problem
$data_worksheet->write('U49', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('U50', '=IF(T50 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U51', '=IF(T51 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U52', '=IF(T52 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U53', '=IF(T53 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U54', '=IF(T54 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U55', '=IF(T55 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U56', '=IF(T56 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U57', '=IF(T57 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U58', '=IF(T58 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U59', '=IF(T59 >= 0,"OK","NON OVERLAP")');

#determine distance between minimum model and maximum 
$data_worksheet->write('V49', 'model max - in vivo min CI95 (old model)');
$data_worksheet->write_formula('V50', '=P50 - (B50 - 1.96 * C50)');
$data_worksheet->write_formula('V51', '=P51 - (B51 - 1.96 * C51)');
$data_worksheet->write_formula('V52', '=P52 - (B52 - 1.96 * C52)');
$data_worksheet->write_formula('V53', '=P53 - (B53 - 1.96 * C53)');
$data_worksheet->write_formula('V54', '=P54 - (B54 - 1.96 * C54)');
$data_worksheet->write_formula('V55', '=P55 - (B55 - 1.96 * C55)');
$data_worksheet->write_formula('V56', '=P56 - (B56 - 1.96 * C56)');
$data_worksheet->write_formula('V57', '=P57 - (B57 - 1.96 * C57)');
$data_worksheet->write_formula('V58', '=P58 - (B58 - 1.96 * C58)');
$data_worksheet->write_formula('V59', '=P59 - (B59 - 1.96 * C59)');

$data_worksheet->write('W49', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('W50', '=IF(V50 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W51', '=IF(V51 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W52', '=IF(V52 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W53', '=IF(V53 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W54', '=IF(V54 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W55', '=IF(V55 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W56', '=IF(V56 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W57', '=IF(V57 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W58', '=IF(V58 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W59', '=IF(V59 >= 0,"OK","NON OVERLAP")');

#logic to see if min - max is a problem
$data_worksheet->write('X49', 'overlap assessment (old model)');
$data_worksheet->write('X50', '=IF(COUNTIF(W50,"=OK") + COUNTIF(U50,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X51', '=IF(COUNTIF(W51,"=OK") + COUNTIF(U51,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X52', '=IF(COUNTIF(W52,"=OK") + COUNTIF(U52,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X53', '=IF(COUNTIF(W53,"=OK") + COUNTIF(U53,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X54', '=IF(COUNTIF(W54,"=OK") + COUNTIF(U54,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X55', '=IF(COUNTIF(W55,"=OK") + COUNTIF(U55,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X56', '=IF(COUNTIF(W56,"=OK") + COUNTIF(U56,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X57', '=IF(COUNTIF(W57,"=OK") + COUNTIF(U57,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X58', '=IF(COUNTIF(W58,"=OK") + COUNTIF(U58,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X59', '=IF(COUNTIF(W59,"=OK") + COUNTIF(U59,"=OK") = 2,"OK","NON OVERLAP")');

############################### pyruvate yield table ##############################
$data_worksheet->write('A61', 'PYRUVATE');
$data_worksheet->write('A62', 'LL1004');
$data_worksheet->write('A63', 'AVM008');
$data_worksheet->write('A64', 'AVM051');
$data_worksheet->write('A65', 'AVM003');
$data_worksheet->write('A66', 'AVM059');
$data_worksheet->write('A67', 'AVM053');
$data_worksheet->write('A68', 'AVM052');
$data_worksheet->write('A69', 'AVM060');
$data_worksheet->write('A70', 'AVM056');
$data_worksheet->write('A71', 'AVM061');

#populate in vivo data
$data_worksheet->write('B61', 'mean in vivo yield (mol/mol)');
$data_worksheet->write('B62', '0.07259');
$data_worksheet->write('B63', '0.08690');
$data_worksheet->write('B64', '0.10192');
$data_worksheet->write('B65', '0.11560');
$data_worksheet->write('B66', '0.08279');
$data_worksheet->write('B67', '0.13683');
$data_worksheet->write('B68', '0.11499');
$data_worksheet->write('B69', '0.11980');
$data_worksheet->write('B70', '0.11087');
$data_worksheet->write('B71', '0.09233');

#populate in vivo data
$data_worksheet->write('C61', 'stdev in vivo yield (mol/mol)');
$data_worksheet->write('C62', '0.004192');
$data_worksheet->write('C63', '0.005787');
$data_worksheet->write('C64', '0.008977');
$data_worksheet->write('C65', '0.003518');
$data_worksheet->write('C66', '0.001894');
$data_worksheet->write('C67', '0.026162');
$data_worksheet->write('C68', '0.001435');
$data_worksheet->write('C69', '0.004917');
$data_worksheet->write('C70', '0.002421');
$data_worksheet->write('C71', '0.001930');

$data_worksheet->write('D61', 'CI error bars (1.96 * stdev)');
$data_worksheet->write_formula('D62', '=1.96*C62');
$data_worksheet->write_formula('D63', '=1.96*C63');
$data_worksheet->write_formula('D64', '=1.96*C64');
$data_worksheet->write_formula('D65', '=1.96*C65');
$data_worksheet->write_formula('D66', '=1.96*C66');
$data_worksheet->write_formula('D67', '=1.96*C67');
$data_worksheet->write_formula('D68', '=1.96*C68');
$data_worksheet->write_formula('D69', '=1.96*C69');
$data_worksheet->write_formula('D70', '=1.96*C70');
$data_worksheet->write_formula('D71', '=1.96*C71');

#leave space for the old model data
$data_worksheet->write('E61', 'pFBA yield (old model)');

#leave space for the old model data
$data_worksheet->write('F61', 'maximum yield (FVA, old model)');

#leave space for the old model data
$data_worksheet->write('G61', 'minimum yield (FVA, old model)');

#make calculations for the error bars
#upper error bar
$data_worksheet->write('H61', 'error bar upper (old model)');
$data_worksheet->write_formula('H62', '=F62-E62');
$data_worksheet->write_formula('H63', '=F63-E63');
$data_worksheet->write_formula('H64', '=F64-E64');
$data_worksheet->write_formula('H65', '=F65-E65');
$data_worksheet->write_formula('H66', '=F66-E66');
$data_worksheet->write_formula('H67', '=F67-E67');
$data_worksheet->write_formula('H68', '=F68-E68');
$data_worksheet->write_formula('H69', '=F69-E69');
$data_worksheet->write_formula('H70', '=F70-E70');
$data_worksheet->write_formula('H71', '=F71-E71');

#lower error bar
$data_worksheet->write('I61', 'error bar lower (old model)');
$data_worksheet->write_formula('I62', '=E62-G62');
$data_worksheet->write_formula('I63', '=E63-G63');
$data_worksheet->write_formula('I64', '=E64-G64');
$data_worksheet->write_formula('I65', '=E65-G65');
$data_worksheet->write_formula('I66', '=E66-G66');
$data_worksheet->write_formula('I67', '=E67-G67');
$data_worksheet->write_formula('I68', '=E68-G68');
$data_worksheet->write_formula('I69', '=E69-G69');
$data_worksheet->write_formula('I70', '=E70-G70');
$data_worksheet->write_formula('I71', '=E71-G71');

#look for overlap
#determine distance between minimum model and maximum 
$data_worksheet->write('J61', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write_formula('J62', '=(B62 + 1.96 * C62) - G62');
$data_worksheet->write_formula('J63', '=(B63 + 1.96 * C63) - G63');
$data_worksheet->write_formula('J64', '=(B64 + 1.96 * C64) - G64');
$data_worksheet->write_formula('J65', '=(B65 + 1.96 * C65) - G65');
$data_worksheet->write_formula('J66', '=(B66 + 1.96 * C66) - G66');
$data_worksheet->write_formula('J67', '=(B67 + 1.96 * C67) - G67');
$data_worksheet->write_formula('J68', '=(B68 + 1.96 * C68) - G68');
$data_worksheet->write_formula('J69', '=(B69 + 1.96 * C69) - G69');
$data_worksheet->write_formula('J70', '=(B70 + 1.96 * C70) - G70');
$data_worksheet->write_formula('J71', '=(B71 + 1.96 * C71) - G71');

#logic to see if max - min is a problem
$data_worksheet->write('K61', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('K62', '=IF(L62 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K63', '=IF(L63 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K64', '=IF(L64 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K65', '=IF(L65 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K66', '=IF(L66 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K67', '=IF(L67 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K68', '=IF(L68 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K69', '=IF(L69 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K70', '=IF(L70 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K71', '=IF(L71 >= 0,"OK","NON OVERLAP")');

#determine distance between minimum model and maximum 
$data_worksheet->write('L61', 'model max - in vivo min CI95 (old model)');
$data_worksheet->write_formula('L62', '=F62 - (B62 - 1.96 * C62)');
$data_worksheet->write_formula('L63', '=F63 - (B63 - 1.96 * C63)');
$data_worksheet->write_formula('L64', '=F64 - (B64 - 1.96 * C64)');
$data_worksheet->write_formula('L65', '=F65 - (B65 - 1.96 * C65)');
$data_worksheet->write_formula('L66', '=F66 - (B66 - 1.96 * C66)');
$data_worksheet->write_formula('L67', '=F67 - (B67 - 1.96 * C67)');
$data_worksheet->write_formula('L68', '=F68 - (B68 - 1.96 * C68)');
$data_worksheet->write_formula('L69', '=F69 - (B69 - 1.96 * C69)');
$data_worksheet->write_formula('L70', '=F70 - (B70 - 1.96 * C70)');
$data_worksheet->write_formula('L71', '=F71 - (B71 - 1.96 * C71)');

$data_worksheet->write('M61', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('M62', '=IF(L62 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M63', '=IF(L63 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M64', '=IF(L64 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M65', '=IF(L65 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M66', '=IF(L66 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M67', '=IF(L67 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M68', '=IF(L68 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M69', '=IF(L69 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M70', '=IF(L70 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M71', '=IF(L71 >= 0,"OK","NON OVERLAP")');

#logic to see if min - max is a problem
$data_worksheet->write('N61', 'overlap assessment (old model)');
$data_worksheet->write('N62', '=IF(COUNTIF(K62,"=OK") + COUNTIF(M62,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N63', '=IF(COUNTIF(K63,"=OK") + COUNTIF(M63,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N64', '=IF(COUNTIF(K64,"=OK") + COUNTIF(M64,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N65', '=IF(COUNTIF(K65,"=OK") + COUNTIF(M65,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N66', '=IF(COUNTIF(K66,"=OK") + COUNTIF(M66,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N67', '=IF(COUNTIF(K67,"=OK") + COUNTIF(M67,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N68', '=IF(COUNTIF(K68,"=OK") + COUNTIF(M68,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N69', '=IF(COUNTIF(K69,"=OK") + COUNTIF(M69,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N70', '=IF(COUNTIF(K70,"=OK") + COUNTIF(M70,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N71', '=IF(COUNTIF(K71,"=OK") + COUNTIF(M71,"=OK") = 2,"OK","NON OVERLAP")');

#leave space for the new model data
$data_worksheet->write('O61', 'pFBA yield (new model)');

#leave space for the new model data
$data_worksheet->write('P61', 'maximum yield (FVA, new model)');

#leave space for the new model data
$data_worksheet->write('Q61', 'minimum yield (FVA, new model)');

#make calculations for the error bars
#upper error bar
$data_worksheet->write('R61', 'error bar upper (old model)');
$data_worksheet->write_formula('R62', '=P62-O62');
$data_worksheet->write_formula('R63', '=P63-O63');
$data_worksheet->write_formula('R64', '=P64-O64');
$data_worksheet->write_formula('R65', '=P65-O65');
$data_worksheet->write_formula('R66', '=P66-O66');
$data_worksheet->write_formula('R67', '=P67-O67');
$data_worksheet->write_formula('R68', '=P68-O68');
$data_worksheet->write_formula('R69', '=P69-O69');
$data_worksheet->write_formula('R70', '=P70-O70');
$data_worksheet->write_formula('R71', '=P71-O71');

#lower error bar
$data_worksheet->write('S61', 'error bar lower (old model)');
$data_worksheet->write_formula('S62', '=O62-Q62');
$data_worksheet->write_formula('S63', '=O63-Q63');
$data_worksheet->write_formula('S64', '=O64-Q64');
$data_worksheet->write_formula('S65', '=O65-Q65');
$data_worksheet->write_formula('S66', '=O66-Q66');
$data_worksheet->write_formula('S67', '=O67-Q67');
$data_worksheet->write_formula('S68', '=O68-Q68');
$data_worksheet->write_formula('S69', '=O69-Q69');
$data_worksheet->write_formula('S70', '=O70-Q70');
$data_worksheet->write_formula('S71', '=O71-Q71');

#look for overlap
#determine distance between minimum model and maximum 
$data_worksheet->write('T61', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write_formula('T62', '=(B62 + 1.96 * C62) - Q62');
$data_worksheet->write_formula('T63', '=(B63 + 1.96 * C63) - Q63');
$data_worksheet->write_formula('T64', '=(B64 + 1.96 * C64) - Q64');
$data_worksheet->write_formula('T65', '=(B65 + 1.96 * C65) - Q65');
$data_worksheet->write_formula('T66', '=(B66 + 1.96 * C66) - Q66');
$data_worksheet->write_formula('T67', '=(B67 + 1.96 * C67) - Q67');
$data_worksheet->write_formula('T68', '=(B68 + 1.96 * C68) - Q68');
$data_worksheet->write_formula('T69', '=(B69 + 1.96 * C69) - Q69');
$data_worksheet->write_formula('T70', '=(B70 + 1.96 * C70) - Q70');
$data_worksheet->write_formula('T71', '=(B71 + 1.96 * C71) - Q71');

#logic to see if max - min is a problem
$data_worksheet->write('U61', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('U62', '=IF(T62 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U63', '=IF(T63 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U64', '=IF(T64 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U65', '=IF(T65 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U66', '=IF(T66 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U67', '=IF(T67 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U68', '=IF(T68 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U69', '=IF(T69 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U70', '=IF(T70 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U71', '=IF(T71 >= 0,"OK","NON OVERLAP")');

#determine distance between minimum model and maximum 
$data_worksheet->write('V61', 'model max - in vivo min CI95 (old model)');
$data_worksheet->write_formula('V62', '=P62 - (B62 - 1.96 * C62)');
$data_worksheet->write_formula('V63', '=P63 - (B63 - 1.96 * C63)');
$data_worksheet->write_formula('V64', '=P64 - (B64 - 1.96 * C64)');
$data_worksheet->write_formula('V65', '=P65 - (B65 - 1.96 * C65)');
$data_worksheet->write_formula('V66', '=P66 - (B66 - 1.96 * C66)');
$data_worksheet->write_formula('V67', '=P67 - (B67 - 1.96 * C67)');
$data_worksheet->write_formula('V68', '=P68 - (B68 - 1.96 * C68)');
$data_worksheet->write_formula('V69', '=P69 - (B69 - 1.96 * C69)');
$data_worksheet->write_formula('V70', '=P70 - (B70 - 1.96 * C70)');
$data_worksheet->write_formula('V71', '=P71 - (B71 - 1.96 * C71)');

$data_worksheet->write('W61', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('W62', '=IF(V62 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W63', '=IF(V63 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W64', '=IF(V64 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W65', '=IF(V65 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W66', '=IF(V66 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W67', '=IF(V67 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W68', '=IF(V68 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W69', '=IF(V69 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W70', '=IF(V70 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W71', '=IF(V71 >= 0,"OK","NON OVERLAP")');

#logic to see if min - max is a problem
$data_worksheet->write('X61', 'overlap assessment (old model)');
$data_worksheet->write('X62', '=IF(COUNTIF(W62,"=OK") + COUNTIF(U62,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X63', '=IF(COUNTIF(W63,"=OK") + COUNTIF(U63,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X64', '=IF(COUNTIF(W64,"=OK") + COUNTIF(U64,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X65', '=IF(COUNTIF(W65,"=OK") + COUNTIF(U65,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X66', '=IF(COUNTIF(W66,"=OK") + COUNTIF(U66,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X67', '=IF(COUNTIF(W67,"=OK") + COUNTIF(U67,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X68', '=IF(COUNTIF(W68,"=OK") + COUNTIF(U68,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X69', '=IF(COUNTIF(W69,"=OK") + COUNTIF(U69,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X70', '=IF(COUNTIF(W70,"=OK") + COUNTIF(U70,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X71', '=IF(COUNTIF(W71,"=OK") + COUNTIF(U71,"=OK") = 2,"OK","NON OVERLAP")');

############################### malate yield table ##############################
$data_worksheet->write('A73', 'MALATE');
$data_worksheet->write('A74', 'LL1004');
$data_worksheet->write('A75', 'AVM008');
$data_worksheet->write('A76', 'AVM051');
$data_worksheet->write('A77', 'AVM003');
$data_worksheet->write('A78', 'AVM059');
$data_worksheet->write('A79', 'AVM053');
$data_worksheet->write('A80', 'AVM052');
$data_worksheet->write('A81', 'AVM060');
$data_worksheet->write('A82', 'AVM056');
$data_worksheet->write('A83', 'AVM061');

#populate in vivo data
$data_worksheet->write('B73', 'mean in vivo yield (mol/mol)');
$data_worksheet->write('B74', '0.00982');
$data_worksheet->write('B75', '0.01613');
$data_worksheet->write('B76', '0.01078');
$data_worksheet->write('B77', '0.01929');
$data_worksheet->write('B78', '0.00692');
$data_worksheet->write('B79', '0.01044');
$data_worksheet->write('B80', '0.02417');
$data_worksheet->write('B81', '0.01501');
$data_worksheet->write('B82', '0.01054');
$data_worksheet->write('B83', '0.01461');

#populate in vivo data
$data_worksheet->write('C73', 'stdev in vivo yield (mol/mol)');
$data_worksheet->write('C74', '0.002562');
$data_worksheet->write('C75', '0.004667');
$data_worksheet->write('C76', '0.001791');
$data_worksheet->write('C77', '0.003251');
$data_worksheet->write('C78', '0.000901');
$data_worksheet->write('C79', '0.003160');
$data_worksheet->write('C80', '0.001336');
$data_worksheet->write('C81', '0.006589');
$data_worksheet->write('C82', '0.000557');
$data_worksheet->write('C83', '0.001506');

$data_worksheet->write('D73', 'CI error bars (1.96 * stdev)');
$data_worksheet->write_formula('D74', '=1.96*C74');
$data_worksheet->write_formula('D75', '=1.96*C75');
$data_worksheet->write_formula('D76', '=1.96*C76');
$data_worksheet->write_formula('D77', '=1.96*C77');
$data_worksheet->write_formula('D78', '=1.96*C78');
$data_worksheet->write_formula('D79', '=1.96*C79');
$data_worksheet->write_formula('D80', '=1.96*C80');
$data_worksheet->write_formula('D81', '=1.96*C81');
$data_worksheet->write_formula('D82', '=1.96*C82');
$data_worksheet->write_formula('D83', '=1.96*C83');

#leave space for the old model data
$data_worksheet->write('E73', 'pFBA yield (old model)');

#leave space for the old model data
$data_worksheet->write('F73', 'maximum yield (FVA, old model)');

#leave space for the old model data
$data_worksheet->write('G73', 'minimum yield (FVA, old model)');

#make calculations for the error bars
#upper error bar
$data_worksheet->write('H73', 'error bar upper (old model)');
$data_worksheet->write_formula('H74', '=F74-E74');
$data_worksheet->write_formula('H75', '=F75-E75');
$data_worksheet->write_formula('H76', '=F76-E76');
$data_worksheet->write_formula('H77', '=F77-E77');
$data_worksheet->write_formula('H78', '=F78-E78');
$data_worksheet->write_formula('H79', '=F79-E79');
$data_worksheet->write_formula('H80', '=F80-E80');
$data_worksheet->write_formula('H81', '=F81-E81');
$data_worksheet->write_formula('H82', '=F82-E82');
$data_worksheet->write_formula('H83', '=F83-E83');

#lower error bar
$data_worksheet->write('I73', 'error bar lower (old model)');
$data_worksheet->write_formula('I74', '=E74-G74');
$data_worksheet->write_formula('I75', '=E75-G75');
$data_worksheet->write_formula('I76', '=E76-G76');
$data_worksheet->write_formula('I77', '=E77-G77');
$data_worksheet->write_formula('I78', '=E78-G78');
$data_worksheet->write_formula('I79', '=E79-G79');
$data_worksheet->write_formula('I80', '=E80-G80');
$data_worksheet->write_formula('I81', '=E81-G81');
$data_worksheet->write_formula('I82', '=E82-G82');
$data_worksheet->write_formula('I83', '=E83-G83');

#look for overlap
#determine distance between minimum model and maximum 
$data_worksheet->write('J73', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write_formula('J74', '=(B74 + 1.96 * C74) - G74');
$data_worksheet->write_formula('J75', '=(B75 + 1.96 * C75) - G75');
$data_worksheet->write_formula('J76', '=(B76 + 1.96 * C76) - G76');
$data_worksheet->write_formula('J77', '=(B77 + 1.96 * C77) - G77');
$data_worksheet->write_formula('J78', '=(B78 + 1.96 * C78) - G78');
$data_worksheet->write_formula('J79', '=(B79 + 1.96 * C79) - G79');
$data_worksheet->write_formula('J80', '=(B80 + 1.96 * C80) - G80');
$data_worksheet->write_formula('J81', '=(B81 + 1.96 * C81) - G81');
$data_worksheet->write_formula('J82', '=(B82 + 1.96 * C82) - G82');
$data_worksheet->write_formula('J83', '=(B83 + 1.96 * C83) - G83');

#logic to see if max - min is a problem
$data_worksheet->write('K73', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('K74', '=IF(L74 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K75', '=IF(L75 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K76', '=IF(L76 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K77', '=IF(L77 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K78', '=IF(L78 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K79', '=IF(L79 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K80', '=IF(L80 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K81', '=IF(L81 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K82', '=IF(L82 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('K83', '=IF(L83 >= 0,"OK","NON OVERLAP")');

#determine distance between minimum model and maximum 
$data_worksheet->write('L73', 'model max - in vivo min CI95 (old model)');
$data_worksheet->write_formula('L74', '=F74 - (B74 - 1.96 * C74)');
$data_worksheet->write_formula('L75', '=F75 - (B75 - 1.96 * C75)');
$data_worksheet->write_formula('L76', '=F76 - (B76 - 1.96 * C76)');
$data_worksheet->write_formula('L77', '=F77 - (B77 - 1.96 * C77)');
$data_worksheet->write_formula('L78', '=F78 - (B78 - 1.96 * C78)');
$data_worksheet->write_formula('L79', '=F79 - (B79 - 1.96 * C79)');
$data_worksheet->write_formula('L80', '=F80 - (B80 - 1.96 * C80)');
$data_worksheet->write_formula('L81', '=F81 - (B81 - 1.96 * C81)');
$data_worksheet->write_formula('L82', '=F82 - (B82 - 1.96 * C82)');
$data_worksheet->write_formula('L83', '=F83 - (B83 - 1.96 * C83)');

$data_worksheet->write('M73', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('M74', '=IF(L74 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M75', '=IF(L75 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M76', '=IF(L76 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M77', '=IF(L77 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M78', '=IF(L78 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M79', '=IF(L79 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M80', '=IF(L80 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M81', '=IF(L81 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M82', '=IF(L82 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('M83', '=IF(L83 >= 0,"OK","NON OVERLAP")');

#logic to see if min - max is a problem
$data_worksheet->write('N73', 'overlap assessment (old model)');
$data_worksheet->write('N74', '=IF(COUNTIF(K74,"=OK") + COUNTIF(M74,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N75', '=IF(COUNTIF(K75,"=OK") + COUNTIF(M75,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N76', '=IF(COUNTIF(K76,"=OK") + COUNTIF(M76,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N77', '=IF(COUNTIF(K77,"=OK") + COUNTIF(M77,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N78', '=IF(COUNTIF(K78,"=OK") + COUNTIF(M78,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N79', '=IF(COUNTIF(K79,"=OK") + COUNTIF(M79,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N80', '=IF(COUNTIF(K80,"=OK") + COUNTIF(M80,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N81', '=IF(COUNTIF(K81,"=OK") + COUNTIF(M81,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N82', '=IF(COUNTIF(K82,"=OK") + COUNTIF(M82,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('N83', '=IF(COUNTIF(K83,"=OK") + COUNTIF(M83,"=OK") = 2,"OK","NON OVERLAP")');

#leave space for the new model data
$data_worksheet->write('O73', 'pFBA yield (new model)');

#leave space for the new model data
$data_worksheet->write('P73', 'maximum yield (FVA, new model)');

#leave space for the new model data
$data_worksheet->write('Q73', 'minimum yield (FVA, new model)');

#make calculations for the error bars
#upper error bar
$data_worksheet->write('R73', 'error bar upper (old model)');
$data_worksheet->write_formula('R74', '=P74-O74');
$data_worksheet->write_formula('R75', '=P75-O75');
$data_worksheet->write_formula('R76', '=P76-O76');
$data_worksheet->write_formula('R77', '=P77-O77');
$data_worksheet->write_formula('R78', '=P78-O78');
$data_worksheet->write_formula('R79', '=P79-O79');
$data_worksheet->write_formula('R80', '=P80-O80');
$data_worksheet->write_formula('R81', '=P81-O81');
$data_worksheet->write_formula('R82', '=P82-O82');
$data_worksheet->write_formula('R83', '=P83-O83');

#lower error bar
$data_worksheet->write('S73', 'error bar lower (old model)');
$data_worksheet->write_formula('S74', '=O74-Q74');
$data_worksheet->write_formula('S75', '=O75-Q75');
$data_worksheet->write_formula('S76', '=O76-Q76');
$data_worksheet->write_formula('S77', '=O77-Q77');
$data_worksheet->write_formula('S78', '=O78-Q78');
$data_worksheet->write_formula('S79', '=O79-Q79');
$data_worksheet->write_formula('S80', '=O80-Q80');
$data_worksheet->write_formula('S81', '=O81-Q81');
$data_worksheet->write_formula('S82', '=O82-Q82');
$data_worksheet->write_formula('S83', '=O83-Q83');

#look for overlap
#determine distance between minimum model and maximum 
$data_worksheet->write('T73', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write_formula('T74', '=(B74 + 1.96 * C74) - Q74');
$data_worksheet->write_formula('T75', '=(B75 + 1.96 * C75) - Q75');
$data_worksheet->write_formula('T76', '=(B76 + 1.96 * C76) - Q76');
$data_worksheet->write_formula('T77', '=(B77 + 1.96 * C77) - Q77');
$data_worksheet->write_formula('T78', '=(B78 + 1.96 * C78) - Q78');
$data_worksheet->write_formula('T79', '=(B79 + 1.96 * C79) - Q79');
$data_worksheet->write_formula('T80', '=(B80 + 1.96 * C80) - Q80');
$data_worksheet->write_formula('T81', '=(B81 + 1.96 * C81) - Q81');
$data_worksheet->write_formula('T82', '=(B82 + 1.96 * C82) - Q82');
$data_worksheet->write_formula('T83', '=(B83 + 1.96 * C83) - Q83');

#logic to see if max - min is a problem
$data_worksheet->write('U73', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('U74', '=IF(T74 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U75', '=IF(T75 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U76', '=IF(T76 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U77', '=IF(T77 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U78', '=IF(T78 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U79', '=IF(T79 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U80', '=IF(T80 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U81', '=IF(T81 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U82', '=IF(T82 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('U83', '=IF(T83 >= 0,"OK","NON OVERLAP")');

#determine distance between minimum model and maximum 
$data_worksheet->write('V73', 'model max - in vivo min CI95 (old model)');
$data_worksheet->write_formula('V74', '=P74 - (B74 - 1.96 * C74)');
$data_worksheet->write_formula('V75', '=P75 - (B75 - 1.96 * C75)');
$data_worksheet->write_formula('V76', '=P76 - (B76 - 1.96 * C76)');
$data_worksheet->write_formula('V77', '=P77 - (B77 - 1.96 * C77)');
$data_worksheet->write_formula('V78', '=P78 - (B78 - 1.96 * C78)');
$data_worksheet->write_formula('V79', '=P79 - (B79 - 1.96 * C79)');
$data_worksheet->write_formula('V80', '=P80 - (B80 - 1.96 * C80)');
$data_worksheet->write_formula('V81', '=P81 - (B81 - 1.96 * C81)');
$data_worksheet->write_formula('V82', '=P82 - (B82 - 1.96 * C82)');
$data_worksheet->write_formula('V83', '=P83 - (B83 - 1.96 * C83)');

$data_worksheet->write('W73', 'in vivo max CI95 - model min (old model)');
$data_worksheet->write('W74', '=IF(V74 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W75', '=IF(V75 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W76', '=IF(V76 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W77', '=IF(V77 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W78', '=IF(V78 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W79', '=IF(V79 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W80', '=IF(V80 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W81', '=IF(V81 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W82', '=IF(V82 >= 0,"OK","NON OVERLAP")');
$data_worksheet->write('W83', '=IF(V83 >= 0,"OK","NON OVERLAP")');

#logic to see if min - max is a problem
$data_worksheet->write('X73', 'overlap assessment (old model)');
$data_worksheet->write('X74', '=IF(COUNTIF(W74,"=OK") + COUNTIF(U74,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X75', '=IF(COUNTIF(W75,"=OK") + COUNTIF(U75,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X76', '=IF(COUNTIF(W76,"=OK") + COUNTIF(U76,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X77', '=IF(COUNTIF(W77,"=OK") + COUNTIF(U77,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X78', '=IF(COUNTIF(W78,"=OK") + COUNTIF(U78,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X79', '=IF(COUNTIF(W79,"=OK") + COUNTIF(U79,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X80', '=IF(COUNTIF(W80,"=OK") + COUNTIF(U80,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X81', '=IF(COUNTIF(W81,"=OK") + COUNTIF(U81,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X82', '=IF(COUNTIF(W82,"=OK") + COUNTIF(U82,"=OK") = 2,"OK","NON OVERLAP")');
$data_worksheet->write('X83', '=IF(COUNTIF(W83,"=OK") + COUNTIF(U83,"=OK") = 2,"OK","NON OVERLAP")');

#################################################################################
################################ PERFORMING RUNS ################################
#################################################################################
#comment out this section if just wanting to read the run results


 
#new model runs
system("py run_pFBA_ctherm_yield_tracking_LL1004.py");
system("py run_pFBA_ctherm_yield_tracking_AVM008.py");
system("py run_pFBA_ctherm_yield_tracking_AVM051.py");
system("py run_pFBA_ctherm_yield_tracking_AVM003.py");
system("py run_pFBA_ctherm_yield_tracking_AVM059.py");
system("py run_pFBA_ctherm_yield_tracking_AVM053.py");
system("py run_pFBA_ctherm_yield_tracking_AVM052.py");
system("py run_pFBA_ctherm_yield_tracking_AVM060.py");
system("py run_pFBA_ctherm_yield_tracking_AVM056.py");
system("py run_pFBA_ctherm_yield_tracking_AVM061.py");

#old model runs
system("py run_pFBA_ctherm_yield_tracking_LL1004_old.py");
system("py run_pFBA_ctherm_yield_tracking_AVM008_old.py");
system("py run_pFBA_ctherm_yield_tracking_AVM051_old.py");
system("py run_pFBA_ctherm_yield_tracking_AVM003_old.py");
system("py run_pFBA_ctherm_yield_tracking_AVM059_old.py");
system("py run_pFBA_ctherm_yield_tracking_AVM053_old.py");
system("py run_pFBA_ctherm_yield_tracking_AVM052_old.py");
system("py run_pFBA_ctherm_yield_tracking_AVM060_old.py");
system("py run_pFBA_ctherm_yield_tracking_AVM056_old.py");
system("py run_pFBA_ctherm_yield_tracking_AVM061_old.py");
=pod
=cut
##################################################################################
################################ READINGS RESULTS ################################
##################################################################################
#comment out this section if just wanting to read the run results

#################################### NEW MODEL ###################################

##################################### LL1004 #####################################

#read the results file for the LL1004 strain
open(LL1004IN, "<pFBA_results_ctherm_yield_tracking_LL1004.txt") or die "could not read LL1004 pFBA file, reason: $!\n";
chomp(my @LL1004IN_lines = <LL1004IN>);
my $LL1004_str = join "\n", @LL1004IN_lines;

#search the string for the data we need, write it to the appropriate cells
if($LL1004_str =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('H2', $match);

} elsif($LL1004_str =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('H2', $match);

} else {

  $data_worksheet->write('H2', 0);

}

if($LL1004_str =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O14', $match);

} elsif($LL1004_str =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O14', $match);

} else {

  $data_worksheet->write('O14', 0);

}

if($LL1004_str =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P14', $match);

} elsif($LL1004_str =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P14', $match);

} else {

  $data_worksheet->write('P14', 0);

}

if($LL1004_str =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q14', $match);

} elsif($LL1004_str =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q14', $match);

} else {

  $data_worksheet->write('Q14', 0);

}

if($LL1004_str =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O26', $match);

} elsif($LL1004_str =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O26', $match);

} else {

  $data_worksheet->write('O26', 0);

}

if($LL1004_str =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P26', $match);

} elsif($LL1004_str =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P26', $match);

} else {

  $data_worksheet->write('P26', 0);

}

if($LL1004_str =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q26', $match);

} elsif($LL1004_str =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q26', $match);

} else {

  $data_worksheet->write('Q26', 0);

}

if($LL1004_str =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O38', $match);

} elsif($LL1004_str =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O38', $match);

} else {

  $data_worksheet->write('O38', 0);

}

if($LL1004_str =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P38', $match);

} elsif($LL1004_str =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P38', $match);

} else {

  $data_worksheet->write('P38', 0);

}

if($LL1004_str =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q38', $match);

} elsif($LL1004_str =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q38', $match);

} else {

  $data_worksheet->write('Q38', 0);

}

if($LL1004_str =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O50', $match);

} elsif($LL1004_str =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O50', $match);

} else {

  $data_worksheet->write('O50', 0);

}

if($LL1004_str =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P50', $match);

} elsif($LL1004_str =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P50', $match);

} else {

  $data_worksheet->write('P50', 0);

}

if($LL1004_str =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q50', $match);

} elsif($LL1004_str =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q50', $match);

} else {

  $data_worksheet->write('Q50', 0);

}

if($LL1004_str =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O62', $match);

} elsif($LL1004_str =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O62', $match);

} else {

  $data_worksheet->write('O62', 0);

}

if($LL1004_str =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P62', $match);

} elsif($LL1004_str =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P62', $match);

} else {

  $data_worksheet->write('P62', 0);

}

if($LL1004_str =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q62', $match);

} elsif($LL1004_str =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q62', $match);

} else {

  $data_worksheet->write('Q62', 0);

}

if($LL1004_str =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O74', $match);

} elsif($LL1004_str =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O74', $match);

} else {

  $data_worksheet->write('O74', 0);

}

if($LL1004_str =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P74', $match);

} elsif($LL1004_str =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P74', $match);

} else {

  $data_worksheet->write('P74', 0);

}

if($LL1004_str =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q74', $match);

} elsif($LL1004_str =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q74', $match);

} else {

  $data_worksheet->write('Q74', 0);

}

##################################### AVM008 #####################################

#read the results file for the AVM008 strain
open(AVM008IN, "<pFBA_results_ctherm_yield_tracking_AVM008.txt") or die "could not read AVM008 pFBA file, reason: $!\n";
chomp(my @AVM008IN_lines = <AVM008IN>);
my $AVM008_str = join "\n", @AVM008IN_lines;

#search the string for the data we need, write it to the appropriate cells
if($AVM008_str =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('H3', $match);

} elsif($AVM008_str =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('H3', $match);

} else {

  $data_worksheet->write('H3', 0);

}

if($AVM008_str =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O15', $match);

} elsif($AVM008_str =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O15', $match);

} else {

  $data_worksheet->write('O15', 0);

}

if($AVM008_str =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P15', $match);

} elsif($AVM008_str =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P15', $match);

} else {

  $data_worksheet->write('P15', 0);

}

if($AVM008_str =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q15', $match);

} elsif($AVM008_str =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q15', $match);

} else {

  $data_worksheet->write('Q15', 0);

}

if($AVM008_str =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O27', $match);

} elsif($AVM008_str =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O27', $match);

} else {

  $data_worksheet->write('O27', 0);

}

if($AVM008_str =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P27', $match);

} elsif($AVM008_str =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P27', $match);

} else {

  $data_worksheet->write('P27', 0);

}

if($AVM008_str =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q27', $match);

} elsif($AVM008_str =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q27', $match);

} else {

  $data_worksheet->write('Q27', 0);

}

if($AVM008_str =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O39', $match);

} elsif($AVM008_str =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O39', $match);

} else {

  $data_worksheet->write('O39', 0);

}

if($AVM008_str =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P39', $match);

} elsif($AVM008_str =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P39', $match);

} else {

  $data_worksheet->write('P39', 0);

}

if($AVM008_str =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q39', $match);

} elsif($AVM008_str =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q39', $match);

} else {

  $data_worksheet->write('Q39', 0);

}

if($AVM008_str =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O51', $match);

} elsif($AVM008_str =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O51', $match);

} else {

  $data_worksheet->write('O51', 0);

}

if($AVM008_str =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P51', $match);

} elsif($AVM008_str =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P51', $match);

} else {

  $data_worksheet->write('P51', 0);

}

if($AVM008_str =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q51', $match);

} elsif($AVM008_str =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q51', $match);

} else {

  $data_worksheet->write('Q51', 0);

}

if($AVM008_str =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O63', $match);

} elsif($AVM008_str =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O63', $match);

} else {

  $data_worksheet->write('O63', 0);

}

if($AVM008_str =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P63', $match);

} elsif($AVM008_str =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P63', $match);

} else {

  $data_worksheet->write('P63', 0);

}

if($AVM008_str =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q63', $match);

} elsif($AVM008_str =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q63', $match);

} else {

  $data_worksheet->write('Q63', 0);

}

if($AVM008_str =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O75', $match);

} elsif($AVM008_str =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O75', $match);

} else {

  $data_worksheet->write('O75', 0);

}

if($AVM008_str =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P75', $match);

} elsif($AVM008_str =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P75', $match);

} else {

  $data_worksheet->write('P75', 0);

}

if($AVM008_str =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q75', $match);

} elsif($AVM008_str =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q75', $match);

} else {

  $data_worksheet->write('Q75', 0);

}

##################################### AVM051 #####################################

#read the results file for the AVM051 strain
open(AVM051IN, "<pFBA_results_ctherm_yield_tracking_AVM051.txt") or die "could not read AVM051 pFBA file, reason: $!\n";
chomp(my @AVM051IN_lines = <AVM051IN>);
my $AVM051_str = join "\n", @AVM051IN_lines;

#search the string for the data we need, write it to the appropriate cells
if($AVM051_str =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('H4', $match);

} elsif($AVM051_str =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('H4', $match);

} else {

  $data_worksheet->write('H4', 0);

}

if($AVM051_str =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O16', $match);

} elsif($AVM051_str =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O16', $match);

} else {

  $data_worksheet->write('O16', 0);

}

if($AVM051_str =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P16', $match);

} elsif($AVM051_str =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P16', $match);

} else {

  $data_worksheet->write('P16', 0);

}

if($AVM051_str =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q16', $match);

} elsif($AVM051_str =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q16', $match);

} else {

  $data_worksheet->write('Q16', 0);

}

if($AVM051_str =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O28', $match);

} elsif($AVM051_str =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O28', $match);

} else {

  $data_worksheet->write('O28', 0);

}

if($AVM051_str =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P28', $match);

} elsif($AVM051_str =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P28', $match);

} else {

  $data_worksheet->write('P28', 0);

}

if($AVM051_str =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q28', $match);

} elsif($AVM051_str =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q28', $match);

} else {

  $data_worksheet->write('Q28', 0);

}

if($AVM051_str =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O40', $match);

} elsif($AVM051_str =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O40', $match);

} else {

  $data_worksheet->write('O40', 0);

}

if($AVM051_str =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P40', $match);

} elsif($AVM051_str =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P40', $match);

} else {

  $data_worksheet->write('P40', 0);

}

if($AVM051_str =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q40', $match);

} elsif($AVM051_str =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q40', $match);

} else {

  $data_worksheet->write('Q40', 0);

}

if($AVM051_str =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O52', $match);

} elsif($AVM051_str =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O52', $match);

} else {

  $data_worksheet->write('O52', 0);

}

if($AVM051_str =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P52', $match);

} elsif($AVM051_str =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P52', $match);

} else {

  $data_worksheet->write('P52', 0);

}

if($AVM051_str =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q52', $match);

} elsif($AVM051_str =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q52', $match);

} else {

  $data_worksheet->write('Q52', 0);

}

if($AVM051_str =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O64', $match);

} elsif($AVM051_str =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O64', $match);

} else {

  $data_worksheet->write('O64', 0);

}

if($AVM051_str =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P64', $match);

} elsif($AVM051_str =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P64', $match);

} else {

  $data_worksheet->write('P64', 0);

}

if($AVM051_str =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q64', $match);

} elsif($AVM051_str =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q64', $match);

} else {

  $data_worksheet->write('Q64', 0);

}

if($AVM051_str =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O76', $match);

} elsif($AVM051_str =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O76', $match);

} else {

  $data_worksheet->write('O76', 0);

}

if($AVM051_str =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P76', $match);

} elsif($AVM051_str =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P76', $match);

} else {

  $data_worksheet->write('P76', 0);

}

if($AVM051_str =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q76', $match);

} elsif($AVM051_str =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q76', $match);

} else {

  $data_worksheet->write('Q76', 0);

}


##################################### AVM003 #####################################

#read the results file for the AVM003 strain
open(AVM003IN, "<pFBA_results_ctherm_yield_tracking_AVM003.txt") or die "could not read AVM003 pFBA file, reason: $!\n";
chomp(my @AVM003IN_lines = <AVM003IN>);
my $AVM003_str = join "\n", @AVM003IN_lines;

#search the string for the data we need, write it to the appropriate cells
if($AVM003_str =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('H5', $match);

} elsif($AVM003_str =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('H5', $match);

} else {

  $data_worksheet->write('H5', 0);

}

if($AVM003_str =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O17', $match);

} elsif($AVM003_str =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O17', $match);

} else {

  $data_worksheet->write('O17', 0);

}

if($AVM003_str =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P17', $match);

} elsif($AVM003_str =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P17', $match);

} else {

  $data_worksheet->write('P17', 0);

}

if($AVM003_str =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q17', $match);

} elsif($AVM003_str =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q17', $match);

} else {

  $data_worksheet->write('Q17', 0);

}

if($AVM003_str =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O29', $match);

} elsif($AVM003_str =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O29', $match);

} else {

  $data_worksheet->write('O29', 0);

}

if($AVM003_str =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P29', $match);

} elsif($AVM003_str =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P29', $match);

} else {

  $data_worksheet->write('P29', 0);

}

if($AVM003_str =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q29', $match);

} elsif($AVM003_str =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q29', $match);

} else {

  $data_worksheet->write('Q29', 0);

}

if($AVM003_str =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O41', $match);

} elsif($AVM003_str =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O41', $match);

} else {

  $data_worksheet->write('O41', 0);

}

if($AVM003_str =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P41', $match);

} elsif($AVM003_str =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P41', $match);

} else {

  $data_worksheet->write('P41', 0);

}

if($AVM003_str =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q41', $match);

} elsif($AVM003_str =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q41', $match);

} else {

  $data_worksheet->write('Q41', 0);

}

if($AVM003_str =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O53', $match);

} elsif($AVM003_str =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O53', $match);

} else {

  $data_worksheet->write('O53', 0);

}

if($AVM003_str =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P53', $match);

} elsif($AVM003_str =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P53', $match);

} else {

  $data_worksheet->write('P53', 0);

}

if($AVM003_str =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q53', $match);

} elsif($AVM003_str =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q53', $match);

} else {

  $data_worksheet->write('Q53', 0);

}

if($AVM003_str =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O65', $match);

} elsif($AVM003_str =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O65', $match);

} else {

  $data_worksheet->write('O65', 0);

}

if($AVM003_str =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P65', $match);

} elsif($AVM003_str =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P65', $match);

} else {

  $data_worksheet->write('P65', 0);

}

if($AVM003_str =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q65', $match);

} elsif($AVM003_str =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q65', $match);

} else {

  $data_worksheet->write('Q65', 0);

}

if($AVM003_str =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O77', $match);

} elsif($AVM003_str =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O77', $match);

} else {

  $data_worksheet->write('O77', 0);

}

if($AVM003_str =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P77', $match);

} elsif($AVM003_str =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P77', $match);

} else {

  $data_worksheet->write('P77', 0);

}

if($AVM003_str =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q77', $match);

} elsif($AVM003_str =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q77', $match);

} else {

  $data_worksheet->write('Q77', 0);

}

##################################### AVM059 #####################################

#read the results file for the AVM059 strain
open(AVM059IN, "<pFBA_results_ctherm_yield_tracking_AVM059.txt") or die "could not read AVM059 pFBA file, reason: $!\n";
chomp(my @AVM059IN_lines = <AVM059IN>);
my $AVM059_str = join "\n", @AVM059IN_lines;

#search the string for the data we need, write it to the appropriate cells
if($AVM059_str =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('H6', $match);

} elsif($AVM059_str =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('H6', $match);

} else {

  $data_worksheet->write('H6', 0);

}

if($AVM059_str =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O18', $match);

} elsif($AVM059_str =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O18', $match);

} else {

  $data_worksheet->write('O18', 0);

}

if($AVM059_str =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P18', $match);

} elsif($AVM059_str =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P18', $match);

} else {

  $data_worksheet->write('P18', 0);

}

if($AVM059_str =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q18', $match);

} elsif($AVM059_str =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q18', $match);

} else {

  $data_worksheet->write('Q18', 0);

}

if($AVM059_str =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O30', $match);

} elsif($AVM059_str =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O30', $match);

} else {

  $data_worksheet->write('O30', 0);

}

if($AVM059_str =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P30', $match);

} elsif($AVM059_str =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P30', $match);

} else {

  $data_worksheet->write('P30', 0);

}

if($AVM059_str =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q30', $match);

} elsif($AVM059_str =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q30', $match);

} else {

  $data_worksheet->write('Q30', 0);

}

if($AVM059_str =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O42', $match);

} elsif($AVM059_str =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O42', $match);

} else {

  $data_worksheet->write('O42', 0);

}

if($AVM059_str =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P42', $match);

} elsif($AVM059_str =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P42', $match);

} else {

  $data_worksheet->write('P42', 0);

}

if($AVM059_str =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q42', $match);

} elsif($AVM059_str =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q42', $match);

} else {

  $data_worksheet->write('Q42', 0);

}

if($AVM059_str =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O54', $match);

} elsif($AVM059_str =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O54', $match);

} else {

  $data_worksheet->write('O54', 0);

}

if($AVM059_str =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P54', $match);

} elsif($AVM059_str =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P54', $match);

} else {

  $data_worksheet->write('P54', 0);

}

if($AVM059_str =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q54', $match);

} elsif($AVM059_str =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q54', $match);

} else {

  $data_worksheet->write('Q54', 0);

}

if($AVM059_str =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O66', $match);

} elsif($AVM059_str =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O66', $match);

} else {

  $data_worksheet->write('O66', 0);

}

if($AVM059_str =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P66', $match);

} elsif($AVM059_str =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P66', $match);

} else {

  $data_worksheet->write('P66', 0);

}

if($AVM059_str =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q66', $match);

} elsif($AVM059_str =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q66', $match);

} else {

  $data_worksheet->write('Q66', 0);

}

if($AVM059_str =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O78', $match);

} elsif($AVM059_str =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O78', $match);

} else {

  $data_worksheet->write('O78', 0);

}

if($AVM059_str =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P78', $match);

} elsif($AVM059_str =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P78', $match);

} else {

  $data_worksheet->write('P78', 0);

}

if($AVM059_str =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q78', $match);

} elsif($AVM059_str =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q78', $match);

} else {

  $data_worksheet->write('Q78', 0);

}

##################################### AVM053 #####################################

#read the results file for the AVM053 strain
open(AVM053IN, "<pFBA_results_ctherm_yield_tracking_AVM053.txt") or die "could not read AVM053 pFBA file, reason: $!\n";
chomp(my @AVM053IN_lines = <AVM053IN>);
my $AVM053_str = join "\n", @AVM053IN_lines;

#search the string for the data we need, write it to the appropriate cells
if($AVM053_str =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('H7', $match);

} elsif($AVM053_str =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('H7', $match);

} else {

  $data_worksheet->write('H7', 0);

}

if($AVM053_str =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O19', $match);

} elsif($AVM053_str =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O19', $match);

} else {

  $data_worksheet->write('O19', 0);

}

if($AVM053_str =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P19', $match);

} elsif($AVM053_str =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P19', $match);

} else {

  $data_worksheet->write('P19', 0);

}

if($AVM053_str =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q19', $match);

} elsif($AVM053_str =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q19', $match);

} else {

  $data_worksheet->write('Q19', 0);

}

if($AVM053_str =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O31', $match);

} elsif($AVM053_str =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O31', $match);

} else {

  $data_worksheet->write('O31', 0);

}

if($AVM053_str =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P31', $match);

} elsif($AVM053_str =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P31', $match);

} else {

  $data_worksheet->write('P31', 0);

}

if($AVM053_str =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q31', $match);

} elsif($AVM053_str =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q31', $match);

} else {

  $data_worksheet->write('Q31', 0);

}

if($AVM053_str =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O43', $match);

} elsif($AVM053_str =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O43', $match);

} else {

  $data_worksheet->write('O43', 0);

}

if($AVM053_str =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P43', $match);

} elsif($AVM053_str =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P43', $match);

} else {

  $data_worksheet->write('P43', 0);

}

if($AVM053_str =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q43', $match);

} elsif($AVM053_str =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q43', $match);

} else {

  $data_worksheet->write('Q43', 0);

}

if($AVM053_str =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O55', $match);

} elsif($AVM053_str =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O55', $match);

} else {

  $data_worksheet->write('O55', 0);

}

if($AVM053_str =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P55', $match);

} elsif($AVM053_str =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P55', $match);

} else {

  $data_worksheet->write('P55', 0);

}

if($AVM053_str =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q55', $match);

} elsif($AVM053_str =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q55', $match);

} else {

  $data_worksheet->write('Q55', 0);

}

if($AVM053_str =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O67', $match);

} elsif($AVM053_str =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O67', $match);

} else {

  $data_worksheet->write('O67', 0);

}

if($AVM053_str =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P67', $match);

} elsif($AVM053_str =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P67', $match);

} else {

  $data_worksheet->write('P67', 0);

}

if($AVM053_str =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q67', $match);

} elsif($AVM053_str =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q67', $match);

} else {

  $data_worksheet->write('Q67', 0);

}

if($AVM053_str =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O79', $match);

} elsif($AVM053_str =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O79', $match);

} else {

  $data_worksheet->write('O79', 0);

}

if($AVM053_str =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P79', $match);

} elsif($AVM053_str =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P79', $match);

} else {

  $data_worksheet->write('P79', 0);

}

if($AVM053_str =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q79', $match);

} elsif($AVM053_str =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q79', $match);

} else {

  $data_worksheet->write('Q79', 0);

}

##################################### AVM052 #####################################

#read the results file for the AVM052 strain
open(AVM052IN, "<pFBA_results_ctherm_yield_tracking_AVM052.txt") or die "could not read AVM052 pFBA file, reason: $!\n";
chomp(my @AVM052IN_lines = <AVM052IN>);
my $AVM052_str = join "\n", @AVM052IN_lines;

#search the string for the data we need, write it to the appropriate cells
if($AVM052_str =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('H8', $match);

} elsif($AVM052_str =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('H8', $match);

} else {

  $data_worksheet->write('H8', 0);

}

if($AVM052_str =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O20', $match);

} elsif($AVM052_str =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O20', $match);

} else {

  $data_worksheet->write('O20', 0);

}

if($AVM052_str =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P20', $match);

} elsif($AVM052_str =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P20', $match);

} else {

  $data_worksheet->write('P20', 0);

}

if($AVM052_str =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q20', $match);

} elsif($AVM052_str =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q20', $match);

} else {

  $data_worksheet->write('Q20', 0);

}

if($AVM052_str =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O32', $match);

} elsif($AVM052_str =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O32', $match);

} else {

  $data_worksheet->write('O32', 0);

}

if($AVM052_str =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P32', $match);

} elsif($AVM052_str =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P32', $match);

} else {

  $data_worksheet->write('P32', 0);

}

if($AVM052_str =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q32', $match);

} elsif($AVM052_str =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q32', $match);

} else {

  $data_worksheet->write('Q32', 0);

}

if($AVM052_str =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O44', $match);

} elsif($AVM052_str =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O44', $match);

} else {

  $data_worksheet->write('O44', 0);

}

if($AVM052_str =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P44', $match);

} elsif($AVM052_str =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P44', $match);

} else {

  $data_worksheet->write('P44', 0);

}

if($AVM052_str =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q44', $match);

} elsif($AVM052_str =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q44', $match);

} else {

  $data_worksheet->write('Q44', 0);

}

if($AVM052_str =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O56', $match);

} elsif($AVM052_str =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O56', $match);

} else {

  $data_worksheet->write('O56', 0);

}

if($AVM052_str =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P56', $match);

} elsif($AVM052_str =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P56', $match);

} else {

  $data_worksheet->write('P56', 0);

}

if($AVM052_str =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q56', $match);

} elsif($AVM052_str =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q56', $match);

} else {

  $data_worksheet->write('Q56', 0);

}

if($AVM052_str =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O68', $match);

} elsif($AVM052_str =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O68', $match);

} else {

  $data_worksheet->write('O68', 0);

}

if($AVM052_str =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P68', $match);

} elsif($AVM052_str =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P68', $match);

} else {

  $data_worksheet->write('P68', 0);

}

if($AVM052_str =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q68', $match);

} elsif($AVM052_str =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q68', $match);

} else {

  $data_worksheet->write('Q68', 0);

}

if($AVM052_str =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O80', $match);

} elsif($AVM052_str =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O80', $match);

} else {

  $data_worksheet->write('O80', 0);

}

if($AVM052_str =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P80', $match);

} elsif($AVM052_str =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P80', $match);

} else {

  $data_worksheet->write('P80', 0);

}

if($AVM052_str =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q80', $match);

} elsif($AVM052_str =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q80', $match);

} else {

  $data_worksheet->write('Q80', 0);

}

##################################### AVM060 #####################################

#read the results file for the AVM060 strain
open(AVM060IN, "<pFBA_results_ctherm_yield_tracking_AVM060.txt") or die "could not read AVM060 pFBA file, reason: $!\n";
chomp(my @AVM060IN_lines = <AVM060IN>);
my $AVM060_str = join "\n", @AVM060IN_lines;

#search the string for the data we need, write it to the appropriate cells
if($AVM060_str =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('H9', $match);

} elsif($AVM060_str =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('H9', $match);

} else {

  $data_worksheet->write('H9', 0);

}

if($AVM060_str =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O21', $match);

} elsif($AVM060_str =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O21', $match);

} else {

  $data_worksheet->write('O21', 0);

}

if($AVM060_str =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P21', $match);

} elsif($AVM060_str =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P21', $match);

} else {

  $data_worksheet->write('P21', 0);

}

if($AVM060_str =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q21', $match);

} elsif($AVM060_str =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q21', $match);

} else {

  $data_worksheet->write('Q21', 0);

}

if($AVM060_str =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O33', $match);

} elsif($AVM060_str =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O33', $match);

} else {

  $data_worksheet->write('O33', 0);

}

if($AVM060_str =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P33', $match);

} elsif($AVM060_str =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P33', $match);

} else {

  $data_worksheet->write('P33', 0);

}

if($AVM060_str =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q33', $match);

} elsif($AVM060_str =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q33', $match);

} else {

  $data_worksheet->write('Q33', 0);

}

if($AVM060_str =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O45', $match);

} elsif($AVM060_str =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O45', $match);

} else {

  $data_worksheet->write('O45', 0);

}

if($AVM060_str =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P45', $match);

} elsif($AVM060_str =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P45', $match);

} else {

  $data_worksheet->write('P45', 0);

}

if($AVM060_str =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q45', $match);

} elsif($AVM060_str =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q45', $match);

} else {

  $data_worksheet->write('Q45', 0);

}

if($AVM060_str =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O57', $match);

} elsif($AVM060_str =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O57', $match);

} else {

  $data_worksheet->write('O57', 0);

}

if($AVM060_str =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P57', $match);

} elsif($AVM060_str =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P57', $match);

} else {

  $data_worksheet->write('P57', 0);

}

if($AVM060_str =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q57', $match);

} elsif($AVM060_str =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q57', $match);

} else {

  $data_worksheet->write('Q57', 0);

}

if($AVM060_str =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O69', $match);

} elsif($AVM060_str =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O69', $match);

} else {

  $data_worksheet->write('O69', 0);

}

if($AVM060_str =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P69', $match);

} elsif($AVM060_str =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P69', $match);

} else {

  $data_worksheet->write('P69', 0);

}

if($AVM060_str =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q69', $match);

} elsif($AVM060_str =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q69', $match);

} else {

  $data_worksheet->write('Q69', 0);

}

if($AVM060_str =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O81', $match);

} elsif($AVM060_str =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O81', $match);

} else {

  $data_worksheet->write('O81', 0);

}

if($AVM060_str =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P81', $match);

} elsif($AVM060_str =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P81', $match);

} else {

  $data_worksheet->write('P81', 0);

}

if($AVM060_str =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q81', $match);

} elsif($AVM060_str =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q81', $match);

} else {

  $data_worksheet->write('Q81', 0);

}

##################################### AVM056 #####################################

#read the results file for the AVM056 strain
open(AVM056IN, "<pFBA_results_ctherm_yield_tracking_AVM056.txt") or die "could not read AVM056 pFBA file, reason: $!\n";
chomp(my @AVM056IN_lines = <AVM056IN>);
my $AVM056_str = join "\n", @AVM056IN_lines;

#search the string for the data we need, write it to the appropriate cells
if($AVM056_str =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('H10', $match);

} elsif($AVM056_str =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('H10', $match);

} else {

  $data_worksheet->write('H10', 0);

}

if($AVM056_str =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O22', $match);

} elsif($AVM056_str =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O22', $match);

} else {

  $data_worksheet->write('O22', 0);

}

if($AVM056_str =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P22', $match);

} elsif($AVM056_str =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P22', $match);

} else {

  $data_worksheet->write('P22', 0);

}

if($AVM056_str =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q22', $match);

} elsif($AVM056_str =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q22', $match);

} else {

  $data_worksheet->write('Q22', 0);

}

if($AVM056_str =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O34', $match);

} elsif($AVM056_str =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O34', $match);

} else {

  $data_worksheet->write('O34', 0);

}

if($AVM056_str =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P34', $match);

} elsif($AVM056_str =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P34', $match);

} else {

  $data_worksheet->write('P34', 0);

}

if($AVM056_str =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q34', $match);

} elsif($AVM056_str =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q34', $match);

} else {

  $data_worksheet->write('Q34', 0);

}

if($AVM056_str =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O46', $match);

} elsif($AVM056_str =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O46', $match);

} else {

  $data_worksheet->write('O46', 0);

}

if($AVM056_str =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P46', $match);

} elsif($AVM056_str =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P46', $match);

} else {

  $data_worksheet->write('P46', 0);

}

if($AVM056_str =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q46', $match);

} elsif($AVM056_str =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q46', $match);

} else {

  $data_worksheet->write('Q46', 0);

}

if($AVM056_str =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O58', $match);

} elsif($AVM056_str =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O58', $match);

} else {

  $data_worksheet->write('O58', 0);

}

if($AVM056_str =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P58', $match);

} elsif($AVM056_str =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P58', $match);

} else {

  $data_worksheet->write('P58', 0);

}

if($AVM056_str =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q58', $match);

} elsif($AVM056_str =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q58', $match);

} else {

  $data_worksheet->write('Q58', 0);

}

if($AVM056_str =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O70', $match);

} elsif($AVM056_str =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O70', $match);

} else {

  $data_worksheet->write('O70', 0);

}

if($AVM056_str =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P70', $match);

} elsif($AVM056_str =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P70', $match);

} else {

  $data_worksheet->write('P70', 0);

}

if($AVM056_str =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q70', $match);

} elsif($AVM056_str =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q70', $match);

} else {

  $data_worksheet->write('Q70', 0);

}

if($AVM056_str =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O82', $match);

} elsif($AVM056_str =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O82', $match);

} else {

  $data_worksheet->write('O82', 0);

}

if($AVM056_str =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P82', $match);

} elsif($AVM056_str =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P82', $match);

} else {

  $data_worksheet->write('P82', 0);

}

if($AVM056_str =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q82', $match);

} elsif($AVM056_str =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q82', $match);

} else {

  $data_worksheet->write('Q82', 0);

}

##################################### AVM061 #####################################

#read the results file for the AVM061 strain
open(AVM061IN, "<pFBA_results_ctherm_yield_tracking_AVM061.txt") or die "could not read AVM061 pFBA file, reason: $!\n";
chomp(my @AVM061IN_lines = <AVM061IN>);
my $AVM061_str = join "\n", @AVM061IN_lines;

#search the string for the data we need, write it to the appropriate cells
if($AVM061_str =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('H11', $match);

} elsif($AVM061_str =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('H11', $match);

} else {

  $data_worksheet->write('H11', 0);

}

if($AVM061_str =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O23', $match);

} elsif($AVM061_str =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O23', $match);

} else {

  $data_worksheet->write('O23', 0);

}

if($AVM061_str =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P23', $match);

} elsif($AVM061_str =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P23', $match);

} else {

  $data_worksheet->write('P23', 0);

}

if($AVM061_str =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q23', $match);

} elsif($AVM061_str =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q23', $match);

} else {

  $data_worksheet->write('Q23', 0);

}

if($AVM061_str =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O35', $match);

} elsif($AVM061_str =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O35', $match);

} else {

  $data_worksheet->write('O35', 0);

}

if($AVM061_str =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P35', $match);

} elsif($AVM061_str =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P35', $match);

} else {

  $data_worksheet->write('P35', 0);

}

if($AVM061_str =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q35', $match);

} elsif($AVM061_str =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q35', $match);

} else {

  $data_worksheet->write('Q35', 0);

}

if($AVM061_str =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O47', $match);

} elsif($AVM061_str =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O47', $match);

} else {

  $data_worksheet->write('O47', 0);

}

if($AVM061_str =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P47', $match);

} elsif($AVM061_str =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P47', $match);

} else {

  $data_worksheet->write('P47', 0);

}

if($AVM061_str =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q47', $match);

} elsif($AVM061_str =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q47', $match);

} else {

  $data_worksheet->write('Q47', 0);

}

if($AVM061_str =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O59', $match);

} elsif($AVM061_str =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O59', $match);

} else {

  $data_worksheet->write('O59', 0);

}

if($AVM061_str =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P59', $match);

} elsif($AVM061_str =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P59', $match);

} else {

  $data_worksheet->write('P59', 0);

}

if($AVM061_str =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q59', $match);

} elsif($AVM061_str =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q59', $match);

} else {

  $data_worksheet->write('Q59', 0);

}

if($AVM061_str =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O71', $match);

} elsif($AVM061_str =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O71', $match);

} else {

  $data_worksheet->write('O71', 0);

}

if($AVM061_str =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P71', $match);

} elsif($AVM061_str =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P71', $match);

} else {

  $data_worksheet->write('P71', 0);

}

if($AVM061_str =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q71', $match);

} elsif($AVM061_str =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q71', $match);

} else {

  $data_worksheet->write('Q71', 0);

}

if($AVM061_str =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('O83', $match);

} elsif($AVM061_str =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('O83', $match);

} else {

  $data_worksheet->write('O83', 0);

}

if($AVM061_str =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('P83', $match);

} elsif($AVM061_str =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('P83', $match);

} else {

  $data_worksheet->write('P83', 0);

}

if($AVM061_str =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q83', $match);

} elsif($AVM061_str =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('Q83', $match);

} else {

  $data_worksheet->write('Q83', 0);

}


#################################### OLD MODEL ###################################

##################################### LL1004 #####################################

#read the results file for the LL1004 strain
open(LL1004INOLD, "<pFBA_results_ctherm_yield_tracking_LL1004_old.txt") or die "could not read LL1004 pFBA file, reason: $!\n";
chomp(my @LL1004IN_lines_old = <LL1004INOLD>);
my $LL1004_str_old = join "\n", @LL1004IN_lines_old;

#search the string for the data we need, write it to the appropriate cells
if($LL1004_str_old =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E2', $match);

} elsif($LL1004_str_old =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E2', $match);

} else {

  $data_worksheet->write('E2', 0);

}

if($LL1004_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E14', $match);

} elsif($LL1004_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E14', $match);

} else {

  $data_worksheet->write('E14', 0);

}

if($LL1004_str_old =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F14', $match);

} elsif($LL1004_str_old =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F14', $match);

} else {

  $data_worksheet->write('F14', 0);

}

if($LL1004_str_old =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G14', $match);

} elsif($LL1004_str_old =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G14', $match);

} else {

  $data_worksheet->write('G14', 0);

}

if($LL1004_str_old =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E26', $match);

} elsif($LL1004_str_old =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E26', $match);

} else {

  $data_worksheet->write('E26', 0);

}

if($LL1004_str_old =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F26', $match);

} elsif($LL1004_str_old =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F26', $match);

} else {

  $data_worksheet->write('F26', 0);

}

if($LL1004_str_old =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G26', $match);

} elsif($LL1004_str_old =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G26', $match);

} else {

  $data_worksheet->write('G26', 0);

}

if($LL1004_str_old =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E38', $match);

} elsif($LL1004_str_old =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E38', $match);

} else {

  $data_worksheet->write('E38', 0);

}

if($LL1004_str_old =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F38', $match);

} elsif($LL1004_str_old =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F38', $match);

} else {

  $data_worksheet->write('F38', 0);

}

if($LL1004_str_old =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G38', $match);

} elsif($LL1004_str_old =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G38', $match);

} else {

  $data_worksheet->write('G38', 0);

}

if($LL1004_str_old =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E50', $match);

} elsif($LL1004_str_old =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E50', $match);

} else {

  $data_worksheet->write('E50', 0);

}

if($LL1004_str_old =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F50', $match);

} elsif($LL1004_str_old =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F50', $match);

} else {

  $data_worksheet->write('F50', 0);

}

if($LL1004_str_old =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G50', $match);

} elsif($LL1004_str_old =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G50', $match);

} else {

  $data_worksheet->write('G50', 0);

}

if($LL1004_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E62', $match);

} elsif($LL1004_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E62', $match);

} else {

  $data_worksheet->write('E62', 0);

}

if($LL1004_str_old =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F62', $match);

} elsif($LL1004_str_old =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F62', $match);

} else {

  $data_worksheet->write('F62', 0);

}

if($LL1004_str_old =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G62', $match);

} elsif($LL1004_str_old =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G62', $match);

} else {

  $data_worksheet->write('G62', 0);

}

if($LL1004_str_old =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E74', $match);

} elsif($LL1004_str_old =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E74', $match);

} else {

  $data_worksheet->write('E74', 0);

}

if($LL1004_str_old =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F74', $match);

} elsif($LL1004_str_old =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F74', $match);

} else {

  $data_worksheet->write('F74', 0);

}

if($LL1004_str_old =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G74', $match);

} elsif($LL1004_str_old =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G74', $match);

} else {

  $data_worksheet->write('G74', 0);

}

##################################### AVM008 #####################################

#read the results file for the AVM008 strain
open(AVM008INOLD, "<pFBA_results_ctherm_yield_tracking_AVM008_old.txt") or die "could not read AVM008 pFBA file, reason: $!\n";
chomp(my @AVM008IN_lines_old = <AVM008INOLD>);
my $AVM008_str_old = join "\n", @AVM008IN_lines_old;

#search the string for the data we need, write it to the appropriate cells
if($AVM008_str_old =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E3', $match);

} elsif($AVM008_str_old =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E3', $match);

} else {

  $data_worksheet->write('E3', 0);

}

if($AVM008_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E15', $match);

} elsif($AVM008_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E15', $match);

} else {

  $data_worksheet->write('E15', 0);

}

if($AVM008_str_old =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F15', $match);

} elsif($AVM008_str_old =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F15', $match);

} else {

  $data_worksheet->write('F15', 0);

}

if($AVM008_str_old =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G15', $match);

} elsif($AVM008_str_old =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G15', $match);

} else {

  $data_worksheet->write('G15', 0);

}

if($AVM008_str_old =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E27', $match);

} elsif($AVM008_str_old =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E27', $match);

} else {

  $data_worksheet->write('E27', 0);

}

if($AVM008_str_old =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F27', $match);

} elsif($AVM008_str_old =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F27', $match);

} else {

  $data_worksheet->write('F27', 0);

}

if($AVM008_str_old =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G27', $match);

} elsif($AVM008_str_old =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G27', $match);

} else {

  $data_worksheet->write('G27', 0);

}

if($AVM008_str_old =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E39', $match);

} elsif($AVM008_str_old =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E39', $match);

} else {

  $data_worksheet->write('E39', 0);

}

if($AVM008_str_old =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F39', $match);

} elsif($AVM008_str_old =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F39', $match);

} else {

  $data_worksheet->write('F39', 0);

}

if($AVM008_str_old =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G39', $match);

} elsif($AVM008_str_old =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G39', $match);

} else {

  $data_worksheet->write('G39', 0);

}

if($AVM008_str_old =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E51', $match);

} elsif($AVM008_str_old =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E51', $match);

} else {

  $data_worksheet->write('E51', 0);

}

if($AVM008_str_old =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F51', $match);

} elsif($AVM008_str_old =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F51', $match);

} else {

  $data_worksheet->write('F51', 0);

}

if($AVM008_str_old =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G51', $match);

} elsif($AVM008_str_old =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G51', $match);

} else {

  $data_worksheet->write('G51', 0);

}

if($AVM008_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E63', $match);

} elsif($AVM008_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E63', $match);

} else {

  $data_worksheet->write('E63', 0);

}

if($AVM008_str_old =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F63', $match);

} elsif($AVM008_str_old =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F63', $match);

} else {

  $data_worksheet->write('F63', 0);

}

if($AVM008_str_old =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G63', $match);

} elsif($AVM008_str_old =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G63', $match);

} else {

  $data_worksheet->write('G63', 0);

}

if($AVM008_str_old =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E75', $match);

} elsif($AVM008_str_old =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E75', $match);

} else {

  $data_worksheet->write('E75', 0);

}

if($AVM008_str_old =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F75', $match);

} elsif($AVM008_str_old =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F75', $match);

} else {

  $data_worksheet->write('F75', 0);

}

if($AVM008_str_old =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G75', $match);

} elsif($AVM008_str_old =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G75', $match);

} else {

  $data_worksheet->write('G75', 0);

}

##################################### AVM051 #####################################

#read the results file for the AVM051 strain
open(AVM051INOLD, "<pFBA_results_ctherm_yield_tracking_AVM051_old.txt") or die "could not read AVM051 pFBA file, reason: $!\n";
chomp(my @AVM051IN_lines_old = <AVM051INOLD>);
my $AVM051_str_old = join "\n", @AVM051IN_lines_old;

#search the string for the data we need, write it to the appropriate cells
if($AVM051_str_old =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E4', $match);

} elsif($AVM051_str_old =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E4', $match);

} else {

  $data_worksheet->write('E4', 0);

}

if($AVM051_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E16', $match);

} elsif($AVM051_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E16', $match);

} else {

  $data_worksheet->write('E16', 0);

}

if($AVM051_str_old =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F16', $match);

} elsif($AVM051_str_old =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F16', $match);

} else {

  $data_worksheet->write('F16', 0);

}

if($AVM051_str_old =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G16', $match);

} elsif($AVM051_str_old =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G16', $match);

} else {

  $data_worksheet->write('G16', 0);

}

if($AVM051_str_old =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E28', $match);

} elsif($AVM051_str_old =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E28', $match);

} else {

  $data_worksheet->write('E28', 0);

}

if($AVM051_str_old =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F28', $match);

} elsif($AVM051_str_old =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F28', $match);

} else {

  $data_worksheet->write('F28', 0);

}

if($AVM051_str_old =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G28', $match);

} elsif($AVM051_str_old =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G28', $match);

} else {

  $data_worksheet->write('G28', 0);

}

if($AVM051_str_old =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E40', $match);

} elsif($AVM051_str_old =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E40', $match);

} else {

  $data_worksheet->write('E40', 0);

}

if($AVM051_str_old =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F40', $match);

} elsif($AVM051_str_old =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F40', $match);

} else {

  $data_worksheet->write('F40', 0);

}

if($AVM051_str_old =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G40', $match);

} elsif($AVM051_str_old =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G40', $match);

} else {

  $data_worksheet->write('G40', 0);

}

if($AVM051_str_old =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E52', $match);

} elsif($AVM051_str_old =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E52', $match);

} else {

  $data_worksheet->write('E52', 0);

}

if($AVM051_str_old =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F52', $match);

} elsif($AVM051_str_old =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F52', $match);

} else {

  $data_worksheet->write('F52', 0);

}

if($AVM051_str_old =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G52', $match);

} elsif($AVM051_str_old =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G52', $match);

} else {

  $data_worksheet->write('G52', 0);

}

if($AVM051_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E64', $match);

} elsif($AVM051_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E64', $match);

} else {

  $data_worksheet->write('E64', 0);

}

if($AVM051_str_old =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F64', $match);

} elsif($AVM051_str_old =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F64', $match);

} else {

  $data_worksheet->write('F64', 0);

}

if($AVM051_str_old =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G64', $match);

} elsif($AVM051_str_old =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G64', $match);

} else {

  $data_worksheet->write('G64', 0);

}

if($AVM051_str_old =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E76', $match);

} elsif($AVM051_str_old =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E76', $match);

} else {

  $data_worksheet->write('E76', 0);

}

if($AVM051_str_old =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F76', $match);

} elsif($AVM051_str_old =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F76', $match);

} else {

  $data_worksheet->write('F76', 0);

}

if($AVM051_str_old =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G76', $match);

} elsif($AVM051_str_old =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G76', $match);

} else {

  $data_worksheet->write('G76', 0);

}


##################################### AVM003 #####################################

#read the results file for the AVM003 strain
open(AVM003INOLD, "<pFBA_results_ctherm_yield_tracking_AVM003_old.txt") or die "could not read AVM003 pFBA file, reason: $!\n";
chomp(my @AVM003IN_lines_old = <AVM003INOLD>);
my $AVM003_str_old = join "\n", @AVM003IN_lines_old;

#search the string for the data we need, write it to the appropriate cells
if($AVM003_str_old =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E5', $match);

} elsif($AVM003_str_old =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E5', $match);

} else {

  $data_worksheet->write('E5', 0);

}

if($AVM003_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E17', $match);

} elsif($AVM003_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E17', $match);

} else {

  $data_worksheet->write('E17', 0);

}

if($AVM003_str_old =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F17', $match);

} elsif($AVM003_str_old =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F17', $match);

} else {

  $data_worksheet->write('F17', 0);

}

if($AVM003_str_old =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G17', $match);

} elsif($AVM003_str_old =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G17', $match);

} else {

  $data_worksheet->write('G17', 0);

}

if($AVM003_str_old =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E29', $match);

} elsif($AVM003_str_old =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E29', $match);

} else {

  $data_worksheet->write('E29', 0);

}

if($AVM003_str_old =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F29', $match);

} elsif($AVM003_str_old =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F29', $match);

} else {

  $data_worksheet->write('F29', 0);

}

if($AVM003_str_old =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G29', $match);

} elsif($AVM003_str_old =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G29', $match);

} else {

  $data_worksheet->write('G29', 0);

}

if($AVM003_str_old =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E41', $match);

} elsif($AVM003_str_old =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E41', $match);

} else {

  $data_worksheet->write('E41', 0);

}

if($AVM003_str_old =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F41', $match);

} elsif($AVM003_str_old =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F41', $match);

} else {

  $data_worksheet->write('F41', 0);

}

if($AVM003_str_old =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G41', $match);

} elsif($AVM003_str_old =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G41', $match);

} else {

  $data_worksheet->write('G41', 0);

}

if($AVM003_str_old =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E53', $match);

} elsif($AVM003_str_old =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E53', $match);

} else {

  $data_worksheet->write('E53', 0);

}

if($AVM003_str_old =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F53', $match);

} elsif($AVM003_str_old =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F53', $match);

} else {

  $data_worksheet->write('F53', 0);

}

if($AVM003_str_old =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G53', $match);

} elsif($AVM003_str_old =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G53', $match);

} else {

  $data_worksheet->write('G53', 0);

}

if($AVM003_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E65', $match);

} elsif($AVM003_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E65', $match);

} else {

  $data_worksheet->write('E65', 0);

}

if($AVM003_str_old =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F65', $match);

} elsif($AVM003_str_old =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F65', $match);

} else {

  $data_worksheet->write('F65', 0);

}

if($AVM003_str_old =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G65', $match);

} elsif($AVM003_str_old =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G65', $match);

} else {

  $data_worksheet->write('G65', 0);

}

if($AVM003_str_old =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E77', $match);

} elsif($AVM003_str_old =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E77', $match);

} else {

  $data_worksheet->write('E77', 0);

}

if($AVM003_str_old =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F77', $match);

} elsif($AVM003_str_old =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F77', $match);

} else {

  $data_worksheet->write('F77', 0);

}

if($AVM003_str_old =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G77', $match);

} elsif($AVM003_str_old =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G77', $match);

} else {

  $data_worksheet->write('G77', 0);

}

##################################### AVM059 #####################################

#read the results file for the AVM059 strain
open(AVM059INOLD, "<pFBA_results_ctherm_yield_tracking_AVM059_old.txt") or die "could not read AVM059 pFBA file, reason: $!\n";
chomp(my @AVM059IN_lines_old = <AVM059INOLD>);
my $AVM059_str_old = join "\n", @AVM059IN_lines_old;

#search the string for the data we need, write it to the appropriate cells
if($AVM059_str_old =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E6', $match);

} elsif($AVM059_str_old =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E6', $match);

} else {

  $data_worksheet->write('E6', 0);

}

if($AVM059_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E18', $match);

} elsif($AVM059_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E18', $match);

} else {

  $data_worksheet->write('E18', 0);

}

if($AVM059_str_old =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F18', $match);

} elsif($AVM059_str_old =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F18', $match);

} else {

  $data_worksheet->write('F18', 0);

}

if($AVM059_str_old =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G18', $match);

} elsif($AVM059_str_old =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G18', $match);

} else {

  $data_worksheet->write('G18', 0);

}

if($AVM059_str_old =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E30', $match);

} elsif($AVM059_str_old =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E30', $match);

} else {

  $data_worksheet->write('E30', 0);

}

if($AVM059_str_old =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F30', $match);

} elsif($AVM059_str_old =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F30', $match);

} else {

  $data_worksheet->write('F30', 0);

}

if($AVM059_str_old =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G30', $match);

} elsif($AVM059_str_old =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G30', $match);

} else {

  $data_worksheet->write('G30', 0);

}

if($AVM059_str_old =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E42', $match);

} elsif($AVM059_str_old =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E42', $match);

} else {

  $data_worksheet->write('E42', 0);

}

if($AVM059_str_old =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F42', $match);

} elsif($AVM059_str_old =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F42', $match);

} else {

  $data_worksheet->write('F42', 0);

}

if($AVM059_str_old =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G42', $match);

} elsif($AVM059_str_old =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G42', $match);

} else {

  $data_worksheet->write('G42', 0);

}

if($AVM059_str_old =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E54', $match);

} elsif($AVM059_str_old =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E54', $match);

} else {

  $data_worksheet->write('E54', 0);

}

if($AVM059_str_old =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F54', $match);

} elsif($AVM059_str_old =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F54', $match);

} else {

  $data_worksheet->write('F54', 0);

}

if($AVM059_str_old =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G54', $match);

} elsif($AVM059_str_old =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G54', $match);

} else {

  $data_worksheet->write('G54', 0);

}

if($AVM059_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E66', $match);

} elsif($AVM059_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E66', $match);

} else {

  $data_worksheet->write('E66', 0);

}

if($AVM059_str_old =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F66', $match);

} elsif($AVM059_str_old =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F66', $match);

} else {

  $data_worksheet->write('F66', 0);

}

if($AVM059_str_old =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G66', $match);

} elsif($AVM059_str_old =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G66', $match);

} else {

  $data_worksheet->write('G66', 0);

}

if($AVM059_str_old =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E78', $match);

} elsif($AVM059_str_old =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E78', $match);

} else {

  $data_worksheet->write('E78', 0);

}

if($AVM059_str_old =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F78', $match);

} elsif($AVM059_str_old =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F78', $match);

} else {

  $data_worksheet->write('F78', 0);

}

if($AVM059_str_old =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G78', $match);

} elsif($AVM059_str_old =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G78', $match);

} else {

  $data_worksheet->write('G78', 0);

}

##################################### AVM053 #####################################

#read the results file for the AVM053 strain
open(AVM053INOLD, "<pFBA_results_ctherm_yield_tracking_AVM053_old.txt") or die "could not read AVM053 pFBA file, reason: $!\n";
chomp(my @AVM053IN_lines_old = <AVM053INOLD>);
my $AVM053_str_old = join "\n", @AVM053IN_lines_old;

#search the string for the data we need, write it to the appropriate cells
if($AVM053_str_old =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E7', $match);

} elsif($AVM053_str_old =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E7', $match);

} else {

  $data_worksheet->write('E7', 0);

}

if($AVM053_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E19', $match);

} elsif($AVM053_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E19', $match);

} else {

  $data_worksheet->write('E19', 0);

}

if($AVM053_str_old =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F19', $match);

} elsif($AVM053_str_old =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F19', $match);

} else {

  $data_worksheet->write('F19', 0);

}

if($AVM053_str_old =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G19', $match);

} elsif($AVM053_str_old =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G19', $match);

} else {

  $data_worksheet->write('G19', 0);

}

if($AVM053_str_old =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E31', $match);

} elsif($AVM053_str_old =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E31', $match);

} else {

  $data_worksheet->write('E31', 0);

}

if($AVM053_str_old =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F31', $match);

} elsif($AVM053_str_old =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F31', $match);

} else {

  $data_worksheet->write('F31', 0);

}

if($AVM053_str_old =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G31', $match);

} elsif($AVM053_str_old =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G31', $match);

} else {

  $data_worksheet->write('G31', 0);

}

if($AVM053_str_old =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E43', $match);

} elsif($AVM053_str_old =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E43', $match);

} else {

  $data_worksheet->write('E43', 0);

}

if($AVM053_str_old =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F43', $match);

} elsif($AVM053_str_old =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F43', $match);

} else {

  $data_worksheet->write('F43', 0);

}

if($AVM053_str_old =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G43', $match);

} elsif($AVM053_str_old =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G43', $match);

} else {

  $data_worksheet->write('G43', 0);

}

if($AVM053_str_old =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E55', $match);

} elsif($AVM053_str_old =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E55', $match);

} else {

  $data_worksheet->write('E55', 0);

}

if($AVM053_str_old =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F55', $match);

} elsif($AVM053_str_old =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F55', $match);

} else {

  $data_worksheet->write('F55', 0);

}

if($AVM053_str_old =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G55', $match);

} elsif($AVM053_str_old =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G55', $match);

} else {

  $data_worksheet->write('G55', 0);

}

if($AVM053_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E67', $match);

} elsif($AVM053_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E67', $match);

} else {

  $data_worksheet->write('E67', 0);

}

if($AVM053_str_old =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F67', $match);

} elsif($AVM053_str_old =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F67', $match);

} else {

  $data_worksheet->write('F67', 0);

}

if($AVM053_str_old =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G67', $match);

} elsif($AVM053_str_old =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G67', $match);

} else {

  $data_worksheet->write('G67', 0);

}

if($AVM053_str_old =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E79', $match);

} elsif($AVM053_str_old =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E79', $match);

} else {

  $data_worksheet->write('E79', 0);

}

if($AVM053_str_old =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F79', $match);

} elsif($AVM053_str_old =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F79', $match);

} else {

  $data_worksheet->write('F79', 0);

}

if($AVM053_str_old =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G79', $match);

} elsif($AVM053_str_old =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G79', $match);

} else {

  $data_worksheet->write('G79', 0);

}

##################################### AVM052 #####################################

#read the results file for the AVM052 strain
open(AVM052INOLD, "<pFBA_results_ctherm_yield_tracking_AVM052_old.txt") or die "could not read AVM052 pFBA file, reason: $!\n";
chomp(my @AVM052IN_lines_old = <AVM052INOLD>);
my $AVM052_str_old = join "\n", @AVM052IN_lines_old;

#search the string for the data we need, write it to the appropriate cells
if($AVM052_str_old =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E8', $match);

} elsif($AVM052_str_old =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E8', $match);

} else {

  $data_worksheet->write('E8', 0);

}

if($AVM052_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E20', $match);

} elsif($AVM052_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E20', $match);

} else {

  $data_worksheet->write('E20', 0);

}

if($AVM052_str_old =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F20', $match);

} elsif($AVM052_str_old =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F20', $match);

} else {

  $data_worksheet->write('F20', 0);

}

if($AVM052_str_old =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G20', $match);

} elsif($AVM052_str_old =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G20', $match);

} else {

  $data_worksheet->write('G20', 0);

}

if($AVM052_str_old =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E32', $match);

} elsif($AVM052_str_old =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E32', $match);

} else {

  $data_worksheet->write('E32', 0);

}

if($AVM052_str_old =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F32', $match);

} elsif($AVM052_str_old =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F32', $match);

} else {

  $data_worksheet->write('F32', 0);

}

if($AVM052_str_old =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G32', $match);

} elsif($AVM052_str_old =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G32', $match);

} else {

  $data_worksheet->write('G32', 0);

}

if($AVM052_str_old =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E44', $match);

} elsif($AVM052_str_old =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E44', $match);

} else {

  $data_worksheet->write('E44', 0);

}

if($AVM052_str_old =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F44', $match);

} elsif($AVM052_str_old =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F44', $match);

} else {

  $data_worksheet->write('F44', 0);

}

if($AVM052_str_old =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G44', $match);

} elsif($AVM052_str_old =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G44', $match);

} else {

  $data_worksheet->write('G44', 0);

}

if($AVM052_str_old =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E56', $match);

} elsif($AVM052_str_old =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E56', $match);

} else {

  $data_worksheet->write('E56', 0);

}

if($AVM052_str_old =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F56', $match);

} elsif($AVM052_str_old =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F56', $match);

} else {

  $data_worksheet->write('F56', 0);

}

if($AVM052_str_old =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G56', $match);

} elsif($AVM052_str_old =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G56', $match);

} else {

  $data_worksheet->write('G56', 0);

}

if($AVM052_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E68', $match);

} elsif($AVM052_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E68', $match);

} else {

  $data_worksheet->write('E68', 0);

}

if($AVM052_str_old =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F68', $match);

} elsif($AVM052_str_old =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F68', $match);

} else {

  $data_worksheet->write('F68', 0);

}

if($AVM052_str_old =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G68', $match);

} elsif($AVM052_str_old =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G68', $match);

} else {

  $data_worksheet->write('G68', 0);

}

if($AVM052_str_old =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E80', $match);

} elsif($AVM052_str_old =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E80', $match);

} else {

  $data_worksheet->write('E80', 0);

}

if($AVM052_str_old =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F80', $match);

} elsif($AVM052_str_old =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F80', $match);

} else {

  $data_worksheet->write('F80', 0);

}

if($AVM052_str_old =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G80', $match);

} elsif($AVM052_str_old =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G80', $match);

} else {

  $data_worksheet->write('G80', 0);

}

##################################### AVM060 #####################################

#read the results file for the AVM060 strain
open(AVM060INOLD, "<pFBA_results_ctherm_yield_tracking_AVM060_old.txt") or die "could not read AVM060 pFBA file, reason: $!\n";
chomp(my @AVM060IN_lines_old = <AVM060INOLD>);
my $AVM060_str_old = join "\n", @AVM060IN_lines_old;

#search the string for the data we need, write it to the appropriate cells
if($AVM060_str_old =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E9', $match);

} elsif($AVM060_str_old =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E9', $match);

} else {

  $data_worksheet->write('E9', 0);

}

if($AVM060_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E21', $match);

} elsif($AVM060_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E21', $match);

} else {

  $data_worksheet->write('E21', 0);

}

if($AVM060_str_old =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F21', $match);

} elsif($AVM060_str_old =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F21', $match);

} else {

  $data_worksheet->write('F21', 0);

}

if($AVM060_str_old =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G21', $match);

} elsif($AVM060_str_old =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G21', $match);

} else {

  $data_worksheet->write('G21', 0);

}

if($AVM060_str_old =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E33', $match);

} elsif($AVM060_str_old =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E33', $match);

} else {

  $data_worksheet->write('E33', 0);

}

if($AVM060_str_old =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F33', $match);

} elsif($AVM060_str_old =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F33', $match);

} else {

  $data_worksheet->write('F33', 0);

}

if($AVM060_str_old =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G33', $match);

} elsif($AVM060_str_old =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G33', $match);

} else {

  $data_worksheet->write('G33', 0);

}

if($AVM060_str_old =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E45', $match);

} elsif($AVM060_str_old =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E45', $match);

} else {

  $data_worksheet->write('E45', 0);

}

if($AVM060_str_old =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F45', $match);

} elsif($AVM060_str_old =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F45', $match);

} else {

  $data_worksheet->write('F45', 0);

}

if($AVM060_str_old =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G45', $match);

} elsif($AVM060_str_old =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G45', $match);

} else {

  $data_worksheet->write('G45', 0);

}

if($AVM060_str_old =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E57', $match);

} elsif($AVM060_str_old =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E57', $match);

} else {

  $data_worksheet->write('E57', 0);

}

if($AVM060_str_old =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F57', $match);

} elsif($AVM060_str_old =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F57', $match);

} else {

  $data_worksheet->write('F57', 0);

}

if($AVM060_str_old =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G57', $match);

} elsif($AVM060_str_old =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G57', $match);

} else {

  $data_worksheet->write('G57', 0);

}

if($AVM060_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E69', $match);

} elsif($AVM060_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E69', $match);

} else {

  $data_worksheet->write('E69', 0);

}

if($AVM060_str_old =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F69', $match);

} elsif($AVM060_str_old =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F69', $match);

} else {

  $data_worksheet->write('F69', 0);

}

if($AVM060_str_old =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G69', $match);

} elsif($AVM060_str_old =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G69', $match);

} else {

  $data_worksheet->write('G69', 0);

}

if($AVM060_str_old =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E81', $match);

} elsif($AVM060_str_old =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E81', $match);

} else {

  $data_worksheet->write('E81', 0);

}

if($AVM060_str_old =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F81', $match);

} elsif($AVM060_str_old =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F81', $match);

} else {

  $data_worksheet->write('F81', 0);

}

if($AVM060_str_old =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G81', $match);

} elsif($AVM060_str_old =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G81', $match);

} else {

  $data_worksheet->write('G81', 0);

}

##################################### AVM056 #####################################

#read the results file for the AVM056 strain
open(AVM056INOLD, "<pFBA_results_ctherm_yield_tracking_AVM056_old.txt") or die "could not read AVM056 pFBA file, reason: $!\n";
chomp(my @AVM056IN_lines_old = <AVM056INOLD>);
my $AVM056_str_old = join "\n", @AVM056IN_lines_old;

#search the string for the data we need, write it to the appropriate cells
if($AVM056_str_old =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E10', $match);

} elsif($AVM056_str_old =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E10', $match);

} else {

  $data_worksheet->write('E10', 0);

}

if($AVM056_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E22', $match);

} elsif($AVM056_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E22', $match);

} else {

  $data_worksheet->write('E22', 0);

}

if($AVM056_str_old =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F22', $match);

} elsif($AVM056_str_old =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F22', $match);

} else {

  $data_worksheet->write('F22', 0);

}

if($AVM056_str_old =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G22', $match);

} elsif($AVM056_str_old =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G22', $match);

} else {

  $data_worksheet->write('G22', 0);

}

if($AVM056_str_old =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E34', $match);

} elsif($AVM056_str_old =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E34', $match);

} else {

  $data_worksheet->write('E34', 0);

}

if($AVM056_str_old =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F34', $match);

} elsif($AVM056_str_old =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F34', $match);

} else {

  $data_worksheet->write('F34', 0);

}

if($AVM056_str_old =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G34', $match);

} elsif($AVM056_str_old =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G34', $match);

} else {

  $data_worksheet->write('G34', 0);

}

if($AVM056_str_old =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E46', $match);

} elsif($AVM056_str_old =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E46', $match);

} else {

  $data_worksheet->write('E46', 0);

}

if($AVM056_str_old =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F46', $match);

} elsif($AVM056_str_old =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F46', $match);

} else {

  $data_worksheet->write('F46', 0);

}

if($AVM056_str_old =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G46', $match);

} elsif($AVM056_str_old =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G46', $match);

} else {

  $data_worksheet->write('G46', 0);

}

if($AVM056_str_old =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E58', $match);

} elsif($AVM056_str_old =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E58', $match);

} else {

  $data_worksheet->write('E58', 0);

}

if($AVM056_str_old =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F58', $match);

} elsif($AVM056_str_old =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F58', $match);

} else {

  $data_worksheet->write('F58', 0);

}

if($AVM056_str_old =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G58', $match);

} elsif($AVM056_str_old =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G58', $match);

} else {

  $data_worksheet->write('G58', 0);

}

if($AVM056_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E70', $match);

} elsif($AVM056_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E70', $match);

} else {

  $data_worksheet->write('E70', 0);

}

if($AVM056_str_old =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F70', $match);

} elsif($AVM056_str_old =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F70', $match);

} else {

  $data_worksheet->write('F70', 0);

}

if($AVM056_str_old =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G70', $match);

} elsif($AVM056_str_old =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G70', $match);

} else {

  $data_worksheet->write('G70', 0);

}

if($AVM056_str_old =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E82', $match);

} elsif($AVM056_str_old =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E82', $match);

} else {

  $data_worksheet->write('E82', 0);

}

if($AVM056_str_old =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F82', $match);

} elsif($AVM056_str_old =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F82', $match);

} else {

  $data_worksheet->write('F82', 0);

}

if($AVM056_str_old =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G82', $match);

} elsif($AVM056_str_old =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G82', $match);

} else {

  $data_worksheet->write('G82', 0);

}

##################################### AVM061 #####################################

#read the results file for the AVM061 strain
open(AVM061INOLD, "<pFBA_results_ctherm_yield_tracking_AVM061_old.txt") or die "could not read AVM061 pFBA file, reason: $!\n";
chomp(my @AVM061IN_lines_old = <AVM061INOLD>);
my $AVM061_str_old = join "\n", @AVM061IN_lines_old;

#search the string for the data we need, write it to the appropriate cells
if($AVM061_str_old =~ /biomass yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E11', $match);

} elsif($AVM061_str_old =~ /biomass yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E11', $match);

} else {

  $data_worksheet->write('E11', 0);

}

if($AVM061_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E23', $match);

} elsif($AVM061_str_old =~ /ethanol yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E23', $match);

} else {

  $data_worksheet->write('E23', 0);

}

if($AVM061_str_old =~ /ethanol yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F23', $match);

} elsif($AVM061_str_old =~ /ethanol yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F23', $match);

} else {

  $data_worksheet->write('F23', 0);

}

if($AVM061_str_old =~ /ethanol yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G23', $match);

} elsif($AVM061_str_old =~ /ethanol yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G23', $match);

} else {

  $data_worksheet->write('G23', 0);

}

if($AVM061_str_old =~ /acetate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E35', $match);

} elsif($AVM061_str_old =~ /acetate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E35', $match);

} else {

  $data_worksheet->write('E35', 0);

}

if($AVM061_str_old =~ /acetate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F35', $match);

} elsif($AVM061_str_old =~ /acetate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F35', $match);

} else {

  $data_worksheet->write('F35', 0);

}

if($AVM061_str_old =~ /acetate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G35', $match);

} elsif($AVM061_str_old =~ /acetate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G35', $match);

} else {

  $data_worksheet->write('G35', 0);

}

if($AVM061_str_old =~ /formate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E47', $match);

} elsif($AVM061_str_old =~ /formate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E47', $match);

} else {

  $data_worksheet->write('E47', 0);

}

if($AVM061_str_old =~ /formate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F47', $match);

} elsif($AVM061_str_old =~ /formate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F47', $match);

} else {

  $data_worksheet->write('F47', 0);

}

if($AVM061_str_old =~ /formate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G47', $match);

} elsif($AVM061_str_old =~ /formate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G47', $match);

} else {

  $data_worksheet->write('G47', 0);

}

if($AVM061_str_old =~ /lactate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E59', $match);

} elsif($AVM061_str_old =~ /lactate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E59', $match);

} else {

  $data_worksheet->write('E59', 0);

}

if($AVM061_str_old =~ /lactate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F59', $match);

} elsif($AVM061_str_old =~ /lactate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F59', $match);

} else {

  $data_worksheet->write('F59', 0);

}

if($AVM061_str_old =~ /lactate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G59', $match);

} elsif($AVM061_str_old =~ /lactate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G59', $match);

} else {

  $data_worksheet->write('G59', 0);

}

if($AVM061_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E71', $match);

} elsif($AVM061_str_old =~ /pyruvate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E71', $match);

} else {

  $data_worksheet->write('E71', 0);

}

if($AVM061_str_old =~ /pyruvate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F71', $match);

} elsif($AVM061_str_old =~ /pyruvate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F71', $match);

} else {

  $data_worksheet->write('F71', 0);

}

if($AVM061_str_old =~ /pyruvate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G71', $match);

} elsif($AVM061_str_old =~ /pyruvate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G71', $match);

} else {

  $data_worksheet->write('G71', 0);

}

if($AVM061_str_old =~ /malate yield pFBA:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('E83', $match);

} elsif($AVM061_str_old =~ /malate yield pFBA:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('E83', $match);

} else {

  $data_worksheet->write('E83', 0);

}

if($AVM061_str_old =~ /malate yield max:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('F83', $match);

} elsif($AVM061_str_old =~ /malate yield max:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('F83', $match);

} else {

  $data_worksheet->write('F83', 0);

}

if($AVM061_str_old =~ /malate yield min:\s(\d+\.\d+e-*\d+)/) {

  my $match = $1;

  $data_worksheet->write('G83', $match);

} elsif($AVM061_str_old =~ /malate yield min:\s(\d+\.\d+)/) {

  my $match = $1;

  $data_worksheet->write('G83', $match);

} else {

  $data_worksheet->write('G83', 0);

}

##################################################################################
################################### ADD CHARTS ###################################
##################################################################################
#create column charts for easier visual analysis
#add a worksheet for the charts
my $graph_worksheet = $workbook->add_worksheet('teun_comp_graphs');


##################################### BIOMASS ####################################

#start with a chart for biomass yield for both models and in vivo
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add the data for the in vivo yield and associated error bars
$chart-> add_series(

  name          => 'in vivo yield',
  values        => '=teun_comp_data!$B$2:$B$11',
  categories    => '=teun_comp_data!$A$2:$A$11',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$D$2:$D$11',
    minus_values  => '=teun_comp_data!$D$2:$D$11',
  },
  fill          => { color => '#40BFB3' },

);

#note: in vivo data will always be blue (#40BFB3), old model always purple (#B340BF), new model always yellowish (#BFB340)

#add the data for the old model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCBI655 maximum yield',
  values        => '=teun_comp_data!$E$2:$E$11',
  fill          => { color => '#B340BF' },

);

#add the data for the new model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCTH669 maximum yield',
  values        => '=teun_comp_data!$H$2:$H$11',
  fill          => { color => '#BFB340' },

);


#add chart elements for readability
$chart->set_y_axis( name => 'Biomass Yield (g/g cellobiose)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'Biomass Yield Results');
$chart->set_legend( position => 'bottom');

$graph_worksheet->insert_chart('A1', $chart, 0, 0);

#create a chart just for comparing my model to in vivo, as old model will make axis large
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add the data for the in vivo yield and associated error bars
$chart-> add_series(

  name          => 'in vivo yield',
  values        => '=teun_comp_data!$B$2:$B$11',
  categories    => '=teun_comp_data!$A$2:$A$11',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$D$2:$D$11',
    minus_values  => '=teun_comp_data!$D$2:$D$11',
  },
  fill          => { color => '#40BFB3' },

);

#add the data for the new model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCTH669 maximum yield',
  values        => '=teun_comp_data!$H$2:$H$11',
  fill          => { color => '#BFB340' },

);


#add chart elements for readability
$chart->set_y_axis( name => 'Biomass Yield (g/g cellobiose)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'Biomass Yield Results');
$chart->set_legend( position => 'bottom');

$graph_worksheet->insert_chart('I1', $chart, 0, 0);

##################################### ETHANOL ####################################

#create a chart for comparing ethanol yields
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add the data for the in vivo yield and associated error bars
$chart-> add_series(

  name          => 'in vivo yield',
  values        => '=teun_comp_data!$B$14:$B$23',
  categories    => '=teun_comp_data!$A$14:$A$23',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$D$14:$D$23',
    minus_values  => '=teun_comp_data!$D$14:$D$23',
  },
  fill          => { color => '#40BFB3' },

);

#add the data for the old model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCBI655 yield',
  values        => '=teun_comp_data!$E$14:$E$23',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$H$14:$H$23',
    minus_values  => '=teun_comp_data!$I$14:$I$23',
  },
  fill          => { color => '#B340BF' },

);

#add the data for the new model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCTH669 yield',
  values        => '=teun_comp_data!$O$14:$O$23',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$R$14:$R$23',
    minus_values  => '=teun_comp_data!$S$14:$S$23',
  },
  fill          => { color => '#BFB340' },

);


#add chart elements for readability
$chart->set_y_axis( name => 'Ethanol Yield (mmol/mmol cellobiose)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'Ethanol Yield Results');
$chart->set_legend( position => 'bottom');

$graph_worksheet->insert_chart('A16', $chart, 0, 0);

#create a chart for comparing ethanol yields, just for the new model
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add the data for the in vivo yield and associated error bars
$chart-> add_series(

  name          => 'in vivo yield',
  values        => '=teun_comp_data!$B$14:$B$23',
  categories    => '=teun_comp_data!$A$14:$A$23',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$D$14:$D$23',
    minus_values  =>' =teun_comp_data!$D$14:$D$23',
  },
  fill          => { color => '#40BFB3' },

);

#add the data for the new model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCTH669 yield',
  values        => '=teun_comp_data!$O$14:$O$23',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$R$14:$R$23',
    minus_values  => '=teun_comp_data!$S$14:$S$23',
  },
  fill          => { color => '#BFB340' },

);


#add chart elements for readability
$chart->set_y_axis( name => 'Ethanol Yield (mmol/mmol cellobiose)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'Ethanol Yield Results');
$chart->set_legend( position => 'bottom');

$graph_worksheet->insert_chart('I16', $chart, 0, 0);

##################################### ACETATE ####################################

#create a chart for comparing acetate yields
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add the data for the in vivo yield and associated error bars
$chart-> add_series(

  name          => 'in vivo yield',
  values        => '=teun_comp_data!$B$26:$B$35',
  categories    => '=teun_comp_data!$A$26:$A$35',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$D$26:$D$35',
    minus_values  => '=teun_comp_data!$D$26:$D$35',
  },
  fill          => { color => '#40BFB3' },

);

#add the data for the old model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCBI655 yield',
  values        => '=teun_comp_data!$E$26:$E$35',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$H$26:$H$35',
    minus_values  => '=teun_comp_data!$I$26:$I$35',
  },
  fill          => { color => '#B340BF' },

);

#add the data for the new model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCTH669 yield',
  values        => '=teun_comp_data!$O$26:$O$35',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$R$26:$R$35',
    minus_values  => '=teun_comp_data!$S$26:$S$35',
  },
  fill          => { color => '#BFB340' },

);


#add chart elements for readability
$chart->set_y_axis( name => 'Acetate Yield (mmol/mmol cellobiose)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'Acetate Yield Results');
$chart->set_legend( position => 'bottom');

$graph_worksheet->insert_chart('A31', $chart, 0, 0);

#create a chart for comparing acetate yields, just for the new model
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add the data for the in vivo yield and associated error bars
$chart-> add_series(

  name          => 'in vivo yield',
  values        => '=teun_comp_data!$B$26:$B$35',
  categories    => '=teun_comp_data!$A$26:$A$35',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$D$26:$D$35',
    minus_values  => '=teun_comp_data!$D$26:$D$35',
  },
  fill          => { color => '#40BFB3' },

);

#add the data for the new model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCTH669 yield',
  values        => '=teun_comp_data!$O$26:$O$35',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$R$26:$R$35',
    minus_values  => '=teun_comp_data!$S$26:$S$35',
  },
  fill          => { color => '#BFB340' },

);


#add chart elements for readability
$chart->set_y_axis( name => 'Acetate Yield (mmol/mmol cellobiose)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'Acetate Yield Results');
$chart->set_legend( position => 'bottom');

$graph_worksheet->insert_chart('I31', $chart, 0, 0);

##################################### formate ####################################

#create a chart for comparing formate yields
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add the data for the in vivo yield and associated error bars
$chart-> add_series(

  name          => 'in vivo yield',
  values        => '=teun_comp_data!$B$38:$B$47',
  categories    => '=teun_comp_data!$A$38:$A$47',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$D$38:$D$47',
    minus_values  => '=teun_comp_data!$D$38:$D$47',
  },
  fill          => { color => '#40BFB3' },

);

#add the data for the old model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCBI655 yield',
  values        => '=teun_comp_data!$E$38:$E$47',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$H$38:$H$47',
    minus_values  => '=teun_comp_data!$I$38:$I$47',
  },
  fill          => { color => '#B340BF' },

);

#add the data for the new model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCTH669 yield',
  values        => '=teun_comp_data!$O$38:$O$47',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$R$38:$R$47',
    minus_values  => '=teun_comp_data!$S$38:$S$47',
  },
  fill          => { color => '#BFB340' },

);


#add chart elements for readability
$chart->set_y_axis( name => 'Formate Yield (mmol/mmol cellobiose)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'Formate Yield Results');
$chart->set_legend( position => 'bottom');

$graph_worksheet->insert_chart('A46', $chart, 0, 0);

#create a chart for comparing formate yields, just for the new model
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add the data for the in vivo yield and associated error bars
$chart-> add_series(

  name          => 'in vivo yield',
  values        => '=teun_comp_data!$B$38:$B$47',
  categories    => '=teun_comp_data!$A$38:$A$47',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$D$38:$D$47',
    minus_values  => '=teun_comp_data!$D$38:$D$47',
  },
  fill          => { color => '#40BFB3' },

);

#add the data for the new model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCTH669 yield',
  values        => '=teun_comp_data!$O$38:$O$47',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$R$38:$R$47',
    minus_values  => '=teun_comp_data!$S$38:$S$47',
  },
  fill          => { color => '#BFB340' },

);


#add chart elements for readability
$chart->set_y_axis( name => 'Formate Yield (mmol/mmol cellobiose)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'Formate Yield Results');
$chart->set_legend( position => 'bottom');

$graph_worksheet->insert_chart('I46', $chart, 0, 0);

##################################### lactate ####################################

#create a chart for comparing lactate yields
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add the data for the in vivo yield and associated error bars
$chart-> add_series(

  name          => 'in vivo yield',
  values        => '=teun_comp_data!$B$50:$B$59',
  categories    => '=teun_comp_data!$A$50:$A$59',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$D$50:$D$59',
    minus_values  => '=teun_comp_data!$D$50:$D$59',
  },
  fill          => { color => '#40BFB3' },

);

#add the data for the old model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCBI655 yield',
  values        => '=teun_comp_data!$E$50:$E$59',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$H$50:$H$59',
    minus_values  => '=teun_comp_data!$I$50:$I$59',
  },
  fill          => { color => '#B340BF' },

);

#add the data for the new model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCTH669 yield',
  values        => '=teun_comp_data!$O$50:$O$59',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$R$50:$R$59',
    minus_values  => '=teun_comp_data!$S$50:$S$59',
  },
  fill          => { color => '#BFB340' },

);


#add chart elements for readability
$chart->set_y_axis( name => 'Lactate Yield (mmol/mmol cellobiose)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'Lactate Yield Results');
$chart->set_legend( position => 'bottom');

$graph_worksheet->insert_chart('A61', $chart, 0, 0);

#create a chart for comparing lactate yields, just for the new model
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add the data for the in vivo yield and associated error bars
$chart-> add_series(

  name          => 'in vivo yield',
  values        => '=teun_comp_data!$B$50:$B$59',
  categories    => '=teun_comp_data!$A$50:$A$59',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$D$50:$D$59',
    minus_values  => '=teun_comp_data!$D$50:$D$59',
  },
  fill          => { color => '#40BFB3' },

);

#add the data for the new model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCTH669 yield',
  values        => '=teun_comp_data!$O$50:$O$59',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$R$50:$R$59',
    minus_values  => '=teun_comp_data!$S$50:$S$59',
  },
  fill          => { color => '#BFB340' },

);


#add chart elements for readability
$chart->set_y_axis( name => 'Lactate Yield (mmol/mmol cellobiose)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'Lactate Yield Results');
$chart->set_legend( position => 'bottom');

$graph_worksheet->insert_chart('I61', $chart, 0, 0);

##################################### pyruvate ####################################

#create a chart for comparing pyruvate yields
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add the data for the in vivo yield and associated error bars
$chart-> add_series(

  name          => 'in vivo yield',
  values        => '=teun_comp_data!$B$62:$B$71',
  categories    => '=teun_comp_data!$A$62:$A$71',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$D$62:$D$71',
    minus_values  => '=teun_comp_data!$D$62:$D$71',
  },
  fill          => { color => '#40BFB3' },

);

#add the data for the old model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCBI655 yield',
  values        => '=teun_comp_data!$E$62:$E$71',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$H$62:$H$71',
    minus_values  => '=teun_comp_data!$I$62:$I$71',
  },
  fill          => { color => '#B340BF' },

);

#add the data for the new model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCTH669 yield',
  values        => '=teun_comp_data!$O$62:$O$71',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$R$62:$R$71',
    minus_values  => '=teun_comp_data!$S$62:$S$71',
  },
  fill          => { color => '#BFB340' },

);


#add chart elements for readability
$chart->set_y_axis( name => 'Pyruvate Yield (mmol/mmol cellobiose)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'Pyruvate Yield Results');
$chart->set_legend( position => 'bottom');

$graph_worksheet->insert_chart('A76', $chart, 0, 0);

#create a chart for comparing pyruvate yields, just for the new model
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add the data for the in vivo yield and associated error bars
$chart-> add_series(

  name          => 'in vivo yield',
  values        => '=teun_comp_data!$B$62:$B$71',
  categories    => '=teun_comp_data!$A$62:$A$71',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$D$62:$D$71',
    minus_values  => '=teun_comp_data!$D$62:$D$71',
  },
  fill          => { color => '#40BFB3' },

);

#add the data for the new model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCTH669 yield',
  values        => '=teun_comp_data!$O$62:$O$71',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$R$62:$R$71',
    minus_values  => '=teun_comp_data!$S$62:$S$71',
  },
  fill          => { color => '#BFB340' },

);


#add chart elements for readability
$chart->set_y_axis( name => 'Pyruvate Yield (mmol/mmol cellobiose)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'Pyruvate Yield Results');
$chart->set_legend( position => 'bottom');

$graph_worksheet->insert_chart('I76', $chart, 0, 0);

##################################### malate ####################################

#create a chart for comparing malate yields
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add the data for the in vivo yield and associated error bars
$chart-> add_series(

  name          => 'in vivo yield',
  values        => '=teun_comp_data!$B$74:$B$83',
  categories    => '=teun_comp_data!$A$74:$A$83',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$D$74:$D$83',
    minus_values  => '=teun_comp_data!$D$74:$D$83',
  },
  fill          => { color => '#40BFB3' },

);

#add the data for the old model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCBI655 yield',
  values        => '=teun_comp_data!$E$74:$E$83',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$H$74:$H$83',
    minus_values  => '=teun_comp_data!$I$74:$I$83',
  },
  fill          => { color => '#B340BF' },

);

#add the data for the new model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCTH669 yield',
  values        => '=teun_comp_data!$O$74:$O$83',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$R$74:$R$83',
    minus_values  => '=teun_comp_data!$S$74:$S$83',
  },
  fill          => { color => '#BFB340' },

);


#add chart elements for readability
$chart->set_y_axis( name => 'Malate Yield (mmol/mmol cellobiose)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'Malate Yield Results');
$chart->set_legend( position => 'bottom');

$graph_worksheet->insert_chart('A91', $chart, 0, 0);

#create a chart for comparing malate yields, just for the new model
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add the data for the in vivo yield and associated error bars
$chart-> add_series(

  name          => 'in vivo yield',
  values        => '=teun_comp_data!$B$74:$B$83',
  categories    => '=teun_comp_data!$A$74:$A$83',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$D$74:$D$83',
    minus_values  => '=teun_comp_data!$D$74:$D$83',
  },
  fill          => { color => '#40BFB3' },

);

#add the data for the new model yield (no error bars since just looking at max)
$chart-> add_series(

  name          => 'iCTH669 yield',
  values        => '=teun_comp_data!$O$74:$O$83',
  y_error_bars  => {
    type          => 'custom',
    plus_values   => '=teun_comp_data!$R$74:$R$83',
    minus_values  => '=teun_comp_data!$S$74:$S$83',
  },
  fill          => { color => '#BFB340' },

);


#add chart elements for readability
$chart->set_y_axis( name => 'Malate Yield (mmol/mmol cellobiose)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'Malate Yield Results');
$chart->set_legend( position => 'bottom');

$graph_worksheet->insert_chart('I91', $chart, 0, 0);

##################################################################################
############################# TRACKING PYROPHOSHATE ##############################
##################################################################################
#Use this section to run PPi tracking, report on PPi-producing and consuming reactions

##################################### run PPi FVA for PPI reactions #####################################
#run if needed. Essetially runs FBA just on reactions with PPi as a reactant or product, creates producing and consuming files
#where the rate of PPi production or consumption is reported, rather than reaction rate

#create a new workbook sheet for ppi tracking tables
my $ppi_data_worksheet = $workbook->add_worksheet('ppi_tracking_data');

#create a new workbook sheet for ppi tracking graphs
my $ppi_graph_worksheet = $workbook->add_worksheet('ppi_tracking_graphs');

#create a strains array, useful for formatting excel sheet
my @strains = (
  'LL1004',
  'AVM008',
  'AVM051',
  'AVM003',
  'AVM059',
  'AVM053',
  'AVM052',
  'AVM060',
  'AVM056',
  'AVM061',
);



system("py run_fva_ctherm_LL1004_old_ppi.py");
system("py run_fva_ctherm_AVM008_old_ppi.py");
system("py run_fva_ctherm_AVM051_old_ppi.py");
system("py run_fva_ctherm_AVM003_old_ppi.py");
system("py run_fva_ctherm_AVM059_old_ppi.py");
system("py run_fva_ctherm_AVM053_old_ppi.py");
system("py run_fva_ctherm_AVM052_old_ppi.py");
system("py run_fva_ctherm_AVM060_old_ppi.py");
system("py run_fva_ctherm_AVM056_old_ppi.py");
system("py run_fva_ctherm_AVM061_old_ppi.py");

system("py run_fva_ctherm_LL1004_ppi.py");
system("py run_fva_ctherm_AVM008_ppi.py");
system("py run_fva_ctherm_AVM051_ppi.py");
system("py run_fva_ctherm_AVM003_ppi.py");
system("py run_fva_ctherm_AVM059_ppi.py");
system("py run_fva_ctherm_AVM053_ppi.py");
system("py run_fva_ctherm_AVM052_ppi.py");
system("py run_fva_ctherm_AVM060_ppi.py");
system("py run_fva_ctherm_AVM056_ppi.py");
system("py run_fva_ctherm_AVM061_ppi.py");
=pod
=cut
################################### read the old results files ###################################

#build an array for all potential ppi producers, identified by LL1004 run
my @all_ppi_pros_old = ( );

#build an array for all potential ppi consumers, identified by LL1004 run
my @all_ppi_cons_old = ( );

#build a lookup hash for maximum production value by strain and reaction id
my %max_pro_rate_old = ( );

#build a lookup hash for minimum production value by strain and reaction id
my %min_pro_rate_old = ( );

#build a lookup hash for base production value by strain and reaction id
my %base_pro_rate_old = ( );

#build a lookup hash for maximum production value by strain and reaction id
my %max_con_rate_old = ( );

#build a lookup hash for minimum production value by strain and reaction id
my %min_con_rate_old = ( );

#build a lookup hash for base production value by strain and reaction id
my %base_con_rate_old = ( );

#build a lookup hash for stoichiometric coefficient of ppi in given reactions
my %rxn_ppi_coeff_old = ( );

######################################## read LL1004 old #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_LL1004_old.txt") or die "could not read ppi_producing_reactions_LL1004_old, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  #save what we got
  push @all_ppi_pros_old, $id;

  $min_pro_rate_old{'LL1004'}{$id} = $min;
  $max_pro_rate_old{'LL1004'}{$id} = $max;
  $rxn_ppi_coeff_old{$id} = $coeff;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_LL1004_old.txt") or die "could not read ppi_consuming_rxns_LL1004_old, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];

  #save what we got
  push @all_ppi_cons_old, $id;

  $min_con_rate_old{'LL1004'}{$id} = $min;
  $max_con_rate_old{'LL1004'}{$id} = $max;
  $rxn_ppi_coeff_old{$id} = $coeff;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_LL1004_old.txt") or die "could not read pFBA_results_ctherm_yield_tracking_LL1004_old, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros_old) {

    #save the base ppi production rate
    $base_pro_rate_old{'LL1004'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons_old) {

    #save the base ppi consumption rate
    $base_con_rate_old{'LL1004'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM008 old #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM008_old.txt") or die "could not read ppi_producing_reactions_AVM008_old, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate_old{'AVM008'}{$id} = $min;
  $max_pro_rate_old{'AVM008'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM008_old.txt") or die "could not read ppi_consuming_rxns_AVM008_old, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];

  $min_con_rate_old{'AVM008'}{$id} = $min;
  $max_con_rate_old{'AVM008'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM008_old.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM008_old, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros_old) {

    #save the base ppi production rate
    $base_pro_rate_old{'AVM008'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons_old) {

    #save the base ppi consumption rate
    $base_con_rate_old{'AVM008'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM051 old #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM051_old.txt") or die "could not read ppi_producing_reactions_AVM051_old, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate_old{'AVM051'}{$id} = $min;
  $max_pro_rate_old{'AVM051'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM051_old.txt") or die "could not read ppi_consuming_rxns_AVM051_old, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];

  $min_con_rate_old{'AVM051'}{$id} = $min;
  $max_con_rate_old{'AVM051'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM051_old.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM051_old, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros_old) {

    #save the base ppi production rate
    $base_pro_rate_old{'AVM051'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons_old) {

    #save the base ppi consumption rate
    $base_con_rate_old{'AVM051'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM003 old #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM003_old.txt") or die "could not read ppi_producing_reactions_AVM003_old, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate_old{'AVM003'}{$id} = $min;
  $max_pro_rate_old{'AVM003'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM003_old.txt") or die "could not read ppi_consuming_rxns_AVM003_old, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];

  $min_con_rate_old{'AVM003'}{$id} = $min;
  $max_con_rate_old{'AVM003'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM003_old.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM003_old, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros_old) {

    #save the base ppi production rate
    $base_pro_rate_old{'AVM003'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons_old) {

    #save the base ppi consumption rate
    $base_con_rate_old{'AVM003'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM059 old #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM059_old.txt") or die "could not read ppi_producing_reactions_AVM059_old, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate_old{'AVM059'}{$id} = $min;
  $max_pro_rate_old{'AVM059'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM059_old.txt") or die "could not read ppi_consuming_rxns_AVM059_old, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];

  $min_con_rate_old{'AVM059'}{$id} = $min;
  $max_con_rate_old{'AVM059'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM059_old.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM059_old, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros_old) {

    #save the base ppi production rate
    $base_pro_rate_old{'AVM059'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons_old) {

    #save the base ppi consumption rate
    $base_con_rate_old{'AVM059'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM053 old #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM053_old.txt") or die "could not read ppi_producing_reactions_AVM053_old, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate_old{'AVM053'}{$id} = $min;
  $max_pro_rate_old{'AVM053'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM053_old.txt") or die "could not read ppi_consuming_rxns_AVM053_old, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];

  $min_con_rate_old{'AVM053'}{$id} = $min;
  $max_con_rate_old{'AVM053'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM053_old.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM053_old, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros_old) {

    #save the base ppi production rate
    $base_pro_rate_old{'AVM053'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons_old) {

    #save the base ppi consumption rate
    $base_con_rate_old{'AVM053'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #if neither do nothing

}


######################################## read AVM052 old #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM052_old.txt") or die "could not read ppi_producing_reactions_AVM052_old, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate_old{'AVM052'}{$id} = $min;
  $max_pro_rate_old{'AVM052'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM052_old.txt") or die "could not read ppi_consuming_rxns_AVM052_old, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];

  $min_con_rate_old{'AVM052'}{$id} = $min;
  $max_con_rate_old{'AVM052'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM052_old.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM052_old, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros_old) {

    #save the base ppi production rate
    $base_pro_rate_old{'AVM052'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons_old) {

    #save the base ppi consumption rate
    $base_con_rate_old{'AVM052'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM060 old #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM060_old.txt") or die "could not read ppi_producing_reactions_AVM060_old, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate_old{'AVM060'}{$id} = $min;
  $max_pro_rate_old{'AVM060'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM060_old.txt") or die "could not read ppi_consuming_rxns_AVM060_old, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];

  $min_con_rate_old{'AVM060'}{$id} = $min;
  $max_con_rate_old{'AVM060'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM060_old.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM060_old, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros_old) {

    #save the base ppi production rate
    $base_pro_rate_old{'AVM060'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons_old) {

    #save the base ppi consumption rate
    $base_con_rate_old{'AVM060'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM056 old #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM056_old.txt") or die "could not read ppi_producing_reactions_AVM056_old, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate_old{'AVM056'}{$id} = $min;
  $max_pro_rate_old{'AVM056'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM056_old.txt") or die "could not read ppi_consuming_rxns_AVM056_old, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];

  $min_con_rate_old{'AVM056'}{$id} = $min;
  $max_con_rate_old{'AVM056'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM056_old.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM056_old, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros_old) {

    #save the base ppi production rate
    $base_pro_rate_old{'AVM056'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons_old) {

    #save the base ppi consumption rate
    $base_con_rate_old{'AVM056'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM061 old #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM061_old.txt") or die "could not read ppi_producing_reactions_AVM061_old, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate_old{'AVM061'}{$id} = $min;
  $max_pro_rate_old{'AVM061'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM061_old.txt") or die "could not read ppi_consuming_rxns_AVM061_old, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];

  $min_con_rate_old{'AVM061'}{$id} = $min;
  $max_con_rate_old{'AVM061'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM061_old.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM061_old, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros_old) {

    #save the base ppi production rate
    $base_pro_rate_old{'AVM061'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons_old) {

    #save the base ppi consumption rate
    $base_con_rate_old{'AVM061'}{$id} = $rxn_ppi_coeff_old{$id} * $level;

  }

  #if neither do nothing

}

################################### read the new results files ###################################

#build an array for all potential ppi producers, identified by LL1004 run
my @all_ppi_pros = ( );

#build an array for all potential ppi consumers, identified by LL1004 run
my @all_ppi_cons = ( );

#build a lookup hash for maximum production value by strain and reaction id
my %max_pro_rate = ( );

#build a lookup hash for minimum production value by strain and reaction id
my %min_pro_rate = ( );

#build a lookup hash for base production value by strain and reaction id
my %base_pro_rate = ( );

#build a lookup hash for maximum production value by strain and reaction id
my %max_con_rate = ( );

#build a lookup hash for minimum production value by strain and reaction id
my %min_con_rate = ( );

#build a lookup hash for base production value by strain and reaction id
my %base_con_rate = ( );

#build a lookup hash for stoichiometric coefficient of ppi in given reactions
my %rxn_ppi_coeff = ( );


######################################## read LL1004 new #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_LL1004.txt") or die "could not read ppi_producing_reactions_LL1004, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  #save what we got
  push @all_ppi_pros, $id;

  $min_pro_rate{'LL1004'}{$id} = $min;
  $max_pro_rate{'LL1004'}{$id} = $max;
  $rxn_ppi_coeff{$id} = $coeff;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_LL1004.txt") or die "could not read ppi_consuming_rxns_LL1004, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];

  #save what we got
  push @all_ppi_cons, $id;

  $min_con_rate{'LL1004'}{$id} = $min;
  $max_con_rate{'LL1004'}{$id} = $max;
  $rxn_ppi_coeff{$id} = $coeff;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_LL1004.txt") or die "could not read pFBA_results_ctherm_yield_tracking_LL1004, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros) {

    #save the base ppi production rate
    $base_pro_rate{'LL1004'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons) {

    #save the base ppi consumption rate
    $base_con_rate{'LL1004'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM008 new #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM008.txt") or die "could not read ppi_producing_reactions_AVM008, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate{'AVM008'}{$id} = $min;
  $max_pro_rate{'AVM008'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM008.txt") or die "could not read ppi_consuming_rxns_AVM008, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];
  
  $min_con_rate{'AVM008'}{$id} = $min;
  $max_con_rate{'AVM008'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM008.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM008, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros) {

    #save the base ppi production rate
    $base_pro_rate{'AVM008'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons) {

    #save the base ppi consumption rate
    $base_con_rate{'AVM008'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM051 new #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM051.txt") or die "could not read ppi_producing_reactions_AVM051, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate{'AVM051'}{$id} = $min;
  $max_pro_rate{'AVM051'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM051.txt") or die "could not read ppi_consuming_rxns_AVM051, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];
  
  $min_con_rate{'AVM051'}{$id} = $min;
  $max_con_rate{'AVM051'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM051.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM051, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros) {

    #save the base ppi production rate
    $base_pro_rate{'AVM051'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons) {

    #save the base ppi consumption rate
    $base_con_rate{'AVM051'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM003 new #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM003.txt") or die "could not read ppi_producing_reactions_AVM003, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate{'AVM003'}{$id} = $min;
  $max_pro_rate{'AVM003'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM003.txt") or die "could not read ppi_consuming_rxns_AVM003, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];
  
  $min_con_rate{'AVM003'}{$id} = $min;
  $max_con_rate{'AVM003'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM003.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM003, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros) {

    #save the base ppi production rate
    $base_pro_rate{'AVM003'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons) {

    #save the base ppi consumption rate
    $base_con_rate{'AVM003'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM059 new #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM059.txt") or die "could not read ppi_producing_reactions_AVM059, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate{'AVM059'}{$id} = $min;
  $max_pro_rate{'AVM059'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM059.txt") or die "could not read ppi_consuming_rxns_AVM059, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];
  
  $min_con_rate{'AVM059'}{$id} = $min;
  $max_con_rate{'AVM059'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM059.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM059, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros) {

    #save the base ppi production rate
    $base_pro_rate{'AVM059'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons) {

    #save the base ppi consumption rate
    $base_con_rate{'AVM059'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM053 new #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM053.txt") or die "could not read ppi_producing_reactions_AVM053, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate{'AVM053'}{$id} = $min;
  $max_pro_rate{'AVM053'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM053.txt") or die "could not read ppi_consuming_rxns_AVM053, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];
  
  $min_con_rate{'AVM053'}{$id} = $min;
  $max_con_rate{'AVM053'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM053.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM053, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros) {

    #save the base ppi production rate
    $base_pro_rate{'AVM053'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons) {

    #save the base ppi consumption rate
    $base_con_rate{'AVM053'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM052 new #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM052.txt") or die "could not read ppi_producing_reactions_AVM052, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate{'AVM052'}{$id} = $min;
  $max_pro_rate{'AVM052'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM052.txt") or die "could not read ppi_consuming_rxns_AVM052, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];
  
  $min_con_rate{'AVM052'}{$id} = $min;
  $max_con_rate{'AVM052'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM052.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM052, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros) {

    #save the base ppi production rate
    $base_pro_rate{'AVM052'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons) {

    #save the base ppi consumption rate
    $base_con_rate{'AVM052'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM060 new #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM060.txt") or die "could not read ppi_producing_reactions_AVM060, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate{'AVM060'}{$id} = $min;
  $max_pro_rate{'AVM060'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM060.txt") or die "could not read ppi_consuming_rxns_AVM060, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];
  
  $min_con_rate{'AVM060'}{$id} = $min;
  $max_con_rate{'AVM060'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM060.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM060, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros) {

    #save the base ppi production rate
    $base_pro_rate{'AVM060'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons) {

    #save the base ppi consumption rate
    $base_con_rate{'AVM060'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM056 new #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM056.txt") or die "could not read ppi_producing_reactions_AVM056, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate{'AVM056'}{$id} = $min;
  $max_pro_rate{'AVM056'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM056.txt") or die "could not read ppi_consuming_rxns_AVM056, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];
  
  $min_con_rate{'AVM056'}{$id} = $min;
  $max_con_rate{'AVM056'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM056.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM056, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros) {

    #save the base ppi production rate
    $base_pro_rate{'AVM056'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons) {

    #save the base ppi consumption rate
    $base_con_rate{'AVM056'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #if neither do nothing

}

######################################## read AVM061 new #########################################

#read the file into an array
open(PPIPRODS, "<ppi_producing_rxns_AVM061.txt") or die "could not read ppi_producing_reactions_AVM061, reason: $!\n";
chomp(my @ppi_producers = <PPIPRODS>);

#for each element of the array, get ID, min rate, max rate
for(my $f = 0; $f <= $#ppi_producers; $f++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_producers[$f];

  $min_pro_rate{'AVM061'}{$id} = $min;
  $max_pro_rate{'AVM061'}{$id} = $max;

}

#repeat the above for consumers
#read the file
open(PPICONS, "<ppi_consuming_rxns_AVM061.txt") or die "could not read ppi_consuming_rxns_AVM061, reason: $!\n";
chomp(my @ppi_consumers = <PPICONS>);

#for each element of the array, get ID, min rate, max rate
for(my $g = 0; $g <= $#ppi_consumers; $g++) {

  #chop it up into its component pieces
  (my $id, my $min, my $max, my $coeff) = split /\s+/, $ppi_consumers[$g];
  
  $min_con_rate{'AVM061'}{$id} = $min;
  $max_con_rate{'AVM061'}{$id} = $max;

}

#read the ppi tracking file to get ppi base levels into an array
open(BASEFLUXRATES, "<pFBA_results_ctherm_yield_tracking_AVM061.txt") or die "could not read pFBA_results_ctherm_yield_tracking_AVM061, reason: $!\n";
chomp(my @base_flux = <BASEFLUXRATES>);

#remove the data from the end we don't need
#in total 23 lines of this
for(my $i = 0; $i <= 22; $i++) {

  #remove the header
  pop @base_flux;

}

#remove the headers, we don't need this data
#in total, 11 header lines
for(my $j = 0; $j <= 10; $j++) {

  #remove the header
  shift @base_flux;

}

#search the base for our producers and consumers
#then multiply by the coefficient to get 
for(my $h = 0; $h <= $#base_flux; $h++) {

  (my $id, my $min, my $level, my $max) = split /\s+/, $base_flux[$h];

  #check if the reaction is a producer
  if($id ~~ @all_ppi_pros) {

    #save the base ppi production rate
    $base_pro_rate{'AVM061'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #check if the reaction is a consumer
  if($id ~~ @all_ppi_cons) {

    #save the base ppi consumption rate
    $base_con_rate{'AVM061'}{$id} = $rxn_ppi_coeff{$id} * $level;

  }

  #if neither do nothing

}


##################################################################################
############### WRITE THE SIGNIFICANT PPI FLUX TABLES ############################
##################################################################################
#write ppi producing and consuming tables

######################## WRITE iCTH669 PPI PRODUCER TABLE ########################

#write the headers
$ppi_data_worksheet->write(0, 0, 'iCTH669, PPi production by strain, max etoh fixed biomass');
$ppi_data_worksheet->write($#strains + 4, 0, 'iCTH669, PPi production by strain, minimum');
$ppi_data_worksheet->write(2 * $#strains + 8, 0, 'iCTH669, PPi production by strain, maximum');

#keeps a count of the number of reported reactions, no need to report reactions that never carry flux
my $reported_rxns = 0; 

#loop for strains, this defines the rows
for(my $d = 0; $d <= $#strains; $d++) {

  #write the strain label
  #write from row $d+1 because one 
  $ppi_data_worksheet->write($d+2, 0, $strains[$d]);
  $ppi_data_worksheet->write($#strains + $d + 6, 0, $strains[$d]);
  $ppi_data_worksheet->write(2*$#strains + $d + 10, 0, $strains[$d]);

}

#write all the producers
for(my $c = 0; $c <= $#all_ppi_pros; $c++) {

  #check all strains, see if there is some flux in at least one
  my $pro_has_flux = 0;

  for(my $k = 0; $k <= $#strains; $k++) {

    #check if producer has flux either as min, max, or base
    if(($max_pro_rate{$strains[$k]}{$all_ppi_pros[$c]} != 0) || ($min_pro_rate{$strains[$k]}{$all_ppi_pros[$c]} != 0) || ($base_pro_rate{$strains[$k]}{$all_ppi_pros[$c]} != 0)) {

      #if here, the reaction has flux under some condition
      $pro_has_flux = 1;

    }

  }

  #check if there is flux
  if($pro_has_flux == 1) {

    #if here, there is flux (min, max, and/or level) report this reaction
    #write the producer
    #note that writing is indexed from 0, goes row, column
    #write the headers for the reaction to report
    $ppi_data_worksheet->write(1, $reported_rxns+1, $all_ppi_pros[$c]);
    $ppi_data_worksheet->write($#strains + 5, $reported_rxns+1, $all_ppi_pros[$c]." minimum");
    $ppi_data_worksheet->write(2 * $#strains + 9, $reported_rxns+1, $all_ppi_pros[$c]." maximum");

    #write data for each strain
    #write the fluxes through the significant ppi producers
    for(my $l = 0; $l <= $#strains; $l++) {

      $ppi_data_worksheet->write($l + 2, $reported_rxns+1, $base_pro_rate{$strains[$l]}{$all_ppi_pros[$c]});
      $ppi_data_worksheet->write($#strains + $l + 6, $reported_rxns+1, $min_pro_rate{$strains[$l]}{$all_ppi_pros[$c]});
      $ppi_data_worksheet->write(2 * $#strains + $l + 10, $reported_rxns+1, $max_pro_rate{$strains[$l]}{$all_ppi_pros[$c]});

    } #do nothing if not carrying flux at some point

    #increment number of reported reactions
    $reported_rxns++;

  }
  
  #repeat for each reaction

}

######################## WRITE iCTH669 PPI CONSUMER TABLE #########################

#write the headers
$ppi_data_worksheet->write(3 * $#strains + 12, 0, 'iCTH669, PPi consumption by strain, max etoh fixed biomass');
$ppi_data_worksheet->write(4 * $#strains + 16, 0, 'iCTH669, PPi consumption by strain, minimum');
$ppi_data_worksheet->write(5 * $#strains + 20, 0, 'iCTH669, PPi consumption by strain, maximum');

#keeps a count of the number of reported reactions, no need to report reactions that never carry flux
my $reported_rxns = 0; 

#loop for strains, this defines the rows
for(my $d = 0; $d <= $#strains; $d++) {

  #write the strain label
  #write from row $d+1 because one 
  $ppi_data_worksheet->write(3 * $#strains + $d + 14, 0, $strains[$d]);
  $ppi_data_worksheet->write(4 * $#strains + $d + 18, 0, $strains[$d]);
  $ppi_data_worksheet->write(5 * $#strains + $d + 22, 0, $strains[$d]);

}

#write all the producers
for(my $c = 0; $c <= $#all_ppi_cons; $c++) {

  #check all strains, see if there is some flux in at least one
  my $con_has_flux = 0;

  for(my $k = 0; $k <= $#strains; $k++) {

    #check if producer has flux either as min, max, or base
    if(($max_con_rate{$strains[$k]}{$all_ppi_cons[$c]} != 0) || ($min_con_rate{$strains[$k]}{$all_ppi_cons[$c]} != 0) || ($base_con_rate{$strains[$k]}{$all_ppi_cons[$c]} != 0)) {

      #if here, the reaction has flux under some condition
      $con_has_flux = 1;

    }

  }

  #check if there is flux
  if($con_has_flux == 1) {

    #if here, there is flux (min, max, and/or level) report this reaction
    #write the producer
    #note that writing is indexed from 0, goes row, column
    #write the headers for the reaction to report
    $ppi_data_worksheet->write(3 * $#strains + 13, $reported_rxns+1, $all_ppi_cons[$c]);
    $ppi_data_worksheet->write(4 * $#strains + 17, $reported_rxns+1, $all_ppi_cons[$c]." minimum");
    $ppi_data_worksheet->write(5 * $#strains + 21, $reported_rxns+1, $all_ppi_cons[$c]." maximum");

    #write data for each strain
    #write the fluxes through the significant ppi producers
    for(my $l = 0; $l <= $#strains; $l++) {

      $ppi_data_worksheet->write(3 * $#strains + $l + 14, $reported_rxns+1, $base_con_rate{$strains[$l]}{$all_ppi_cons[$c]});
      $ppi_data_worksheet->write(4 * $#strains + $l + 18, $reported_rxns+1, $min_con_rate{$strains[$l]}{$all_ppi_cons[$c]});
      $ppi_data_worksheet->write(5 * $#strains + $l + 22, $reported_rxns+1, $max_con_rate{$strains[$l]}{$all_ppi_cons[$c]});

    } #do nothing if not carrying flux at some point

    #increment number of reported reactions
    $reported_rxns++;

  }
  
  #repeat for each reaction

}

##################################################################################
#################### CREATE CHARTS FOR PPI PRODUCTION ############################
##################################################################################
#create charts so we can see the ranges for PPi production for each strain
#so far just plotting the significant ones

################################ New model #######################################

#need an array to go from number to 
my @num_alph = ( 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' );

#start with a chart for biomass yield for both models and in vivo
my $chart = $workbook->add_chart( type => 'column', embedded => 1);

#add chart elements for readability
$chart->set_y_axis( name => 'PPi Production Rate (mmol/gDW*h)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'PPi Production Rates, iCTH669');
$chart->set_legend( position => 'bottom');

#we will have to create a series for each PPi producer
for(my $f = 0; $f <= $#all_ppi_cons; $f++) {

  #make the values and categories strings
  my $name = '=ppi_tracking_data!$'.$num_alph[$f+1].'$2';
  my $categories = '=ppi_tracking_data!$A$3:$A$'.($#strains+3);
  my $values = '=ppi_tracking_data!$'.$num_alph[$f+1].'$3:$'.$num_alph[$f+1].'$'.($#strains+3);
  my $plus_error = '=ppi_tracking_data!$'.$num_alph[$f+3].'$2:$'.$num_alph[$f+3].'$'.($#strains+3);
  my $minus_error = '=ppi_tracking_data!$D$'.$num_alph[$f+2].':$'.$num_alph[$f+2].'$'.($#strains+3);

  #add the data for the in vivo yield and associated error bars
  $chart-> add_series(

    name          => $name,
    values        => $values,
    categories    => $categories,
    y_error_bars  => {
      type          => 'custom',
      plus_values   => $plus_error,
      minus_values  => $minus_error,
    },

  );

}

#add chart elements for readability
$chart->set_y_axis( name => 'PPi Production Rate (mmol/gDW*h)');
$chart->set_x_axis( name => 'C. thermocellum Strain');
$chart->set_title ( name => 'PPi Production Results, iCTH669');
$chart->set_legend( position => 'bottom');

$ppi_graph_worksheet->insert_chart('A1', $chart, 0, 0);

#close the excel file
$workbook->close();