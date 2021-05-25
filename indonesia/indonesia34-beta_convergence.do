
* Clean you environment
clear all
cls
macro drop _all
set more off


*-------------------------------------------------------
***************** Beta convergence*********************
*-------------------------------------------------------


use "indonesia34withFullDefinitions.dta", clear

* Plots about beta convergence
sc growth ln_gdppc2001

tw (sc growth ln_gdppc2001) (lfit growth ln_gdppc2001)

tw (sc growth ln_gdppc2001, mcolor(dkorange)) (lfit growth ln_gdppc2001, lpattern(solid) lcolor(ebblue) lwidth(medthick)), scale(1.4) ytitle("Growth 2001-2017", color(gs9) size(small)) yscale(lstyle(none)) ylabel(, noticks labcolor(gs10)) xscale(lstyle(none)) xlabel(, noticks labcolor(gs10))  xtitle("Log of GDP per capita in 2001", color(gs9) size(small)) legend(off) name(beta_y, replace)

graph save   "betaConvergence.gph", replace
graph export "betaConvergence.png", replace

* Compute the annual speed of convergence and half live years
reg growth ln_gdppc2001, robust
gen speed = - (log(1+_b[ln_gdppc2001])/(2017-2001))
gen halfLife = log(2)/speed

sum speed  halfLife
