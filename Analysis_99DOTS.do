******************************************************************************************************************
******************************************************************************************************************
******************************************************************************************************************

set more off
clear
cd "C:~\99 DOTS"
import excel using "C:~\99 DOTS\Dataset_99DOTS_01122025.xlsx", firstrow sheet("Sheet1")

************************************************************
asdoc tab Howmuchtimedoesittakefory
asdoc tab Ifeelmoreconnectedtomyheal
asdoc tab TheremindersIreceiveonmyph
asdoc tab Ittakesmetoomuchtimetotak
asdoc tab Imakelesstripstothehealth

************************************************************
gen Ownamobilephone_1=1 if Ownamobilephone=="Owns a personal phone "|Ownamobilephone=="Others"
replace Ownamobilephone_1=2 if Ownamobilephone=="Owns a phone that family shares "
replace Ownamobilephone_1=0 if Ownamobilephone=="Not primary owner of phone family shares "
lab def Ownamobilephone_1 0 "Not primary owner of phone family shares" 1 "Owns a personal phone" 2 "Owns a phone that family shares"
lab val Ownamobilephone_1 Ownamobilephone_1
asdoc tab Digitaladherence_cat Ownamobilephone_1 , row chi

asdoc tab quint if Financialproblem=="Yes"
asdoc tab1 Ifyouareunabletocallfor2

***************************** 
gen edu_cat=0 if Yearsofeducationincompleted=="None"
replace edu_cat=1 if Yearsofeducationincompleted=="Primary"
replace edu_cat=2 if Yearsofeducationincompleted=="Secondary "
replace edu_cat=3 if Yearsofeducationincompleted=="Post-Secondary "
lab def edu_cat 0 "Illiterate" 1 "Primary" 2 "Seconday" 3 "Higher_secondary&above"
lab val edu_cat edu_cat
*recode Yearsofeducationincompleted (0=0 "Illiterate")(1/5=1 "Primary")(6/10=2 "Seconday")(11/12=3 "Higher secondary") (13/17=4 "Postgrad_above"), gen(edu_cat)
asdoc tab edu_cat Ownamobilephone

asdoc tab1 Dial Receivecall Readmessage Writemessage Browseinternet Usesocialnetworkingapplicatio
asdoc tab Dial edu_cat, row chi 
asdoc tab edu_cat Digitaladherence_cat, row chi 

asdoc tab quint Ownamobilephone,row chi
asdoc tab Digitaladherence_cat Ownamobilephone, row
asdoc tab1 DoyouthinkDigitalMonitoring Willyoubesatisfiedenoughto

encode Willyoubesatisfiedenoughto, gen (Willyoubesatisfiedenoughto_n)
recode Willyoubesatisfiedenoughto_n (1=1 "Completely_satisfied") (2=2 "Moderately_satisfied")(4=3 "Slightly_satisfied")(5=4 "Very_satisfied")(3=5 "Not_at_all"), gen(Willyoubesatisfiedenoughto_n1)

/************************************************************************************************************
asdoc tab Digitaladherence_cat1 quint if Digitaladherence_cat1!=0, col chi 
* sig <0.01
asdoc tab Digitaladherence_cat1 quint if Digitaladherence_cat1!=0, row chi 
* sig <0.01
asdoc tab Yearsofeducationincompleted Digitaladherence_cat1, row chi 
* sig <0.01
asdoc tab Averagemonthlyfamilyincome Digitaladherence_cat1, row chi 
* sig <0.01
asdoc tab Ownamobilephone_1 Digitaladherence_cat1, row chi 
* sig <0.01
asdoc tab quint Ownamobilephone_1, row chi
* sig <0.01

asdoc tab Averagemonthlyfamilyincome Digitaladherence_cat1 if Digitaladherence_cat1!=0, row chi 
*/
******************************************************************************************************************
******************************************************************************************************************
******************************************************************************************************************
encode Averagemonthlyfamilyincome, gen(Averagemonthlyfamilyincome_n)

asdoc sum AgeincompletedYear, stat(N mean sd min max p50 p25 p75) dec(2) append
asdoc tab1 Age_cat Gender edu_cat MaritalStatus quint Averagemonthlyfamilyincome Ownamobilephone_1 DiabetesMellitus Hypertension PreviousHistoryofTB Asthma COPD ModeofDiagnosis 
* Specifytechnicalproblem

gen  Network_conn=1 if Ifyouareunabletocallfor2=="Mobile Network connectivity Issue"
replace Network_conn=0 if Network_conn==.

gen  Phone_damaged=1 if Ifyouareunabletocallfor2=="Phone damaged/broken/lost"
replace Phone_damaged=0 if Phone_damaged==.

gen min_balance=1 if Specifyfinancialproblem=="Money Issue"|Specifyfinancialproblem=="Mobile Balance"
replace min_balance=0 if min_balance==.

gen Socialfactors_familial=1 if Socialfactors=="Familial problem"
replace Socialfactors_familial=0 if Socialfactors_familial==.

gen Socialfactors_negCounsel=1 if Socialfactors=="Negative counselling by friends and relatives"
replace Socialfactors_negCounsel=0 if Socialfactors_negCounsel==.

gen Socialfactors_stigma=1 if Socialfactors=="Stigma and discrimination"
replace Socialfactors_stigma=0 if Socialfactors_stigma==. 

tab1 Socialfactors_familial Socialfactors_negCounsel Socialfactors_stigma

*asdoc tab1 Doyouhaveanyproblemscoming DoyouthinkDigitalMonitoring Willyoubesatisfiedenoughto DoyoufindconventionalDOTSsy Doyouthinkyouarecomfortable  Financialproblem Network_conn Phone_damaged min_balance Socialfactors_familial Socialfactors_negCounsel Didyouhavetopayforanything

*ed Doyouhaveanyproblemscoming DoyouthinkDigitalMonitoring Willyoubesatisfiedenoughto DoyoufindconventionalDOTSsy Doyouthinkyouarecomfortable  Financialproblem Didyouhavetopayforanything

/**************************************************************************************
**************************************************************************************
*drop if Digitaladherence_cat1==0
recode Digitaladherence_cat1 (1 2=0 "No")(3 4=1 "Yes"), gen (Digital_new)

byso Digital_new: asdoc summarize AgeincompletedYear , stat(N mean sd min max p50 p25 p75) dec(2) append
ttest AgeincompletedYear, by(Digital_new)
ranksum AgeincompletedYear, by(Digital_new)
*median AgeincompletedYear, by(Digital_new)
byso Digital_new: asdoc summarize Numberoffamilymembers , stat(N mean sd min max p50 p25 p75) dec(2) append
ttest Numberoffamilymembers, by(Digital_new)

asdoc tab1 Age_cat Gender edu_cat MaritalStatus Averagemonthlyfamilyincome quint Ownamobilephone_1 DiabetesMellitus Hypertension Asthma COPD PreviousHistoryofTB ModeofDiagnosis Network_conn Phone_damaged min_balance Socialfactors_familial Socialfactors_negCounsel Doyouhaveanyproblemscoming  DoyouthinkDigitalMonitoring Willyoubesatisfiedenoughto DoyoufindconventionalDOTSsy Doyouthinkyouarecomfortable Financialproblem Didyouhavetopayforanything

foreach var of varlist Age_cat Gender edu_cat MaritalStatus Averagemonthlyfamilyincome quint Ownamobilephone_1 DiabetesMellitus Hypertension Asthma COPD PreviousHistoryofTB ModeofDiagnosis Network_conn Phone_damaged min_balance Socialfactors_familial Socialfactors_negCounsel Doyouhaveanyproblemscoming  DoyouthinkDigitalMonitoring Willyoubesatisfiedenoughto DoyoufindconventionalDOTSsy Doyouthinkyouarecomfortable Financialproblem Didyouhavetopayforanything  {
asdoc tab `var' Digital_new  

}

foreach var of varlist Age_cat Gender edu_cat MaritalStatus Averagemonthlyfamilyincome quint Ownamobilephone_1 DiabetesMellitus Hypertension Asthma COPD PreviousHistoryofTB ModeofDiagnosis Network_conn Phone_damaged min_balance Socialfactors_familial Socialfactors_negCounsel Doyouhaveanyproblemscoming  DoyouthinkDigitalMonitoring Willyoubesatisfiedenoughto DoyoufindconventionalDOTSsy Doyouthinkyouarecomfortable Financialproblem Didyouhavetopayforanything {
asdoc tab `var' Digital_new, row chi nofreq 

}

foreach var of varlist Age_cat Gender edu_cat MaritalStatus Averagemonthlyfamilyincome quint Ownamobilephone_1 DiabetesMellitus Hypertension Asthma COPD PreviousHistoryofTB ModeofDiagnosis Network_conn Phone_damaged min_balance Socialfactors_familial Socialfactors_negCounsel Doyouhaveanyproblemscoming  DoyouthinkDigitalMonitoring Willyoubesatisfiedenoughto DoyoufindconventionalDOTSsy Doyouthinkyouarecomfortable Financialproblem Didyouhavetopayforanything {
tab `var' Digital_new, chi 

}
*/

encode Gender, gen(Gender_n)
encode DiabetesMellitus, gen(DiabetesMellitus_n) 
encode Hypertension, gen(Hypertension_n) 
encode PreviousHistoryofTB, gen(PreviousHistoryofTB_n) 
encode Asthma, gen(Asthma_n) 
encode COPD, gen(COPD_n) 
encode ModeofDiagnosis, gen(ModeofDiagnosis_n)
encode Doyouhaveanyproblemscoming, gen(Doyouhaveanyproblemscoming_n)
encode DoyouthinkDigitalMonitoring, gen(DoyouthinkDigitalMonitoring_n)
encode DoyoufindconventionalDOTSsy, gen(DoyoufindconventionalDOTSsy_n)
encode Doyouthinkyouarecomfortable, gen(Doyouthinkyouarecomfortable_n)
encode Financialproblem, gen(Financialproblem_n)
encode Didyouhavetopayforanything, gen(Didyouhavetopayforanything_n)
recode Gender_n (1=1)(2=0)

foreach var of varlist DiabetesMellitus_n Hypertension_n Asthma_n COPD_n ModeofDiagnosis_n Doyouhaveanyproblemscoming_n Financialproblem_n Didyouhavetopayforanything_n {
	
	recode `var' (1=0 "No")(2=1 "Yes"), gen(`var'1)
	
}

recode PreviousHistoryofTB_n (1 2=0 "No")(3=1 "Yes"), gen (PreviousHistoryofTB_n1)
recode DoyouthinkDigitalMonitoring_n (1 2 4 5=1 "Acceptable")(3=0 "No"), gen (DoyouthinkDigitalMonitoring_n1)
recode Willyoubesatisfiedenoughto_n1 (1/4=1 "Acceptable")(5=0 "No"), gen(Willyoubesatisfiedenoughto_n2)
recode DoyoufindconventionalDOTSsy_n (1=0 "No")(2 3=1 "Yes"), gen(DoyoufindconventionalDOTSsy_n1)
recode Doyouthinkyouarecomfortable_n (3=0 "No")(1 2 4 5=1 "Yes"), gen(Doyouthinkyouarecomfortable_n1)

gen social_barrier=1 if Socialfactors_familial==1|Socialfactors_negCounsel==1|Socialfactors_stigma==1
replace social_barrier=0 if social_barrier==.
tab social_barrier
tab1 DoyouthinkDigitalMonitoring_n1 Willyoubesatisfiedenoughto_n2 DoyoufindconventionalDOTSsy_n1 Doyouthinkyouarecomfortable_n1

recode Digitaladherence (0.1/79.9=0 "<80")(80/100=1 ">=80"), gen(Digital_new_2)
tab Digital_new_2

tab Network_conn Digital_new_2
tab SiteofTuberculosis Digital_new_2
tab ModeofDiagnosis_n Digital_new_2
tab Network_conn quint
ed SiteofTuberculosis ModeofDiagnosis

byso Digital_new_2: asdoc summarize AgeincompletedYear , stat(N mean sd min max p50 p25 p75) dec(2) append
byso Digital_new_2: asdoc summarize Numberoffamilymembers , stat(N mean sd min max p50 p25 p75) dec(2) append

recode Ownamobilephone_1 (0=0) (1 2=1)
foreach var of varlist Age_cat Gender_n edu_cat quint Ownamobilephone_1 DiabetesMellitus_n1 Hypertension_n1 PreviousHistoryofTB_n1 SiteofTuberculosis ModeofDiagnosis_n Network_conn min_balance social_barrier {
tab `var' Digital_new_2, chi 

}

ed Digital_new_2 Age_cat Gender_n edu_cat quint Ownamobilephone_1 DiabetesMellitus_n1 Hypertension_n1 PreviousHistoryofTB_n1 SiteofTuberculosis ModeofDiagnosis_n Network_conn min_balance social_barrier

gen Age_cat_n=0 if Age_cat=="<15"
replace Age_cat_n=1 if Age_cat=="15-24"
replace Age_cat_n=2 if Age_cat=="25-34"
replace Age_cat_n=3 if Age_cat=="35-44"
replace Age_cat_n=4 if Age_cat=="45-54"
replace Age_cat_n=5 if Age_cat=="55-64"
replace Age_cat_n=6 if Age_cat=="65+"
sort Age_cat_n 

gen quint_n=1 if quint=="Poor"
replace quint_n=2 if quint=="Middle"
replace quint_n=3 if quint=="Rich"
tab quint quint_n

gen SiteofTuberculosis_n=1 if SiteofTuberculosis=="EPTB"
replace SiteofTuberculosis_n=0 if SiteofTuberculosis=="PTB"
tab SiteofTuberculosis SiteofTuberculosis_n

******************************************
asdoc logit Digital_new_2 ib0.Age_cat_n,or
asdoc logit Digital_new_2 ib0.Gender_n,or
asdoc logit Digital_new_2 ib0.edu_cat,or
asdoc logit Digital_new_2 ib1.quint_n,or
asdoc logit Digital_new_2 ib0.Ownamobilephone_1,or 
asdoc logit Digital_new_2 ib0.DiabetesMellitus_n1,or 
asdoc logit Digital_new_2 ib0.Hypertension_n1,or
asdoc logit Digital_new_2 ib0.PreviousHistoryofTB_n1,or
asdoc logit Digital_new_2 ib1.Network_conn,or
asdoc logit Digital_new_2 ib1.min_balance,or
asdoc logit Digital_new_2 ib1.social_barrier,or
asdoc logit Digital_new_2 ib0.SiteofTuberculosis_n,or
asdoc logit Digital_new_2 ib1.ModeofDiagnosis_n,or

*********************** Run logistic regression model
asdoc logit Digital_new_2 ib0.edu_cat ib1.quint_n ib0.Ownamobilephone_1 ib1.Network_conn ib1.min_balance ib1.social_barrier ib0.SiteofTuberculosis_n ib1.ModeofDiagnosis_n, or 

*estimates store model1
coefplot, drop(_cons) xline(0) msymbol(S) xtitle(Odds ratio) yscale(alt)










