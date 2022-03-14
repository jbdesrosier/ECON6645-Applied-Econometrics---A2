//ECON 6645 - Assignment 2

cd "D:\Documents\MA Economics\Courses - Winter 2022\ECON6645 - Applied Econometrics\Assignment 2"

//1
clear
use ".\ANES.dta"

decode income_cat, gen(a)

gen str20 s1 = ustrregexs(1) if ustrregexm(a,"([\d,]+)")
gen str20 s2 = ustrregexs(2) if ustrregexm(a,"([\d,]+)[^\d,]+([\d,]+)")
destring s1 s2, ignore(",") generate(L U)
drop a s1 s2

//gen income_mid = (U-L)/2 + L if U !=.
gen income_mid = runiform(L, U)

tab income_cat
/* n^L_T-1 = 254
	N^L_T=122 */
gen a = log(254/122)/log(300000/200000)
gen b = a/(a-1)*299999

replace income_mid=b if income_mid==.
drop L U a b

gen eq_hh_income = income_mid/sqrt(hhold_size)

est clear
estpost tabstat eq_hh_income, c(stat) stat(n mean sd median min max p5 p25 p50 p75 p95)
esttab using tab1.tex, replace ///
 cells("n(fmt(%13.0fc)) mean(fmt(%13.2fc)) sd(fmt(%13.2fc)) median min max p5 p25 p50 p75 p95") nonumber ///
  nomtitle nonote noobs label booktabs ///
	collabels("n" "Mean" "Median" "SD" "Min" "Max" "5%" "25%" "50%" "75%" "95%")

//2
pca job_insecurity worse_next_yr worse_last_yr
predict pca_1
egen egotropic = std(pca_1)

pca poor_economy last_yr next_yr
predict pca_2
egen sociotropic = std(pca_2)

//3
sum authority 
gen authority_stn = (authority-4.345946)/2.598724
gen ln_eq_hh_income = log(eq_hh_income)

est clear
eststo: reg authority_stn ln_eq_hh_income sociotropic egotropic ///
	 visible_minority i.educ born_again age [pweight=weight] if gender==2
eststo: reg authority_stn ln_eq_hh_income sociotropic egotropic ///
	 visible_minority i.educ born_again age [pweight=weight] if gender==1
esttab using tab2.tex



















