
* Clean you environment
clear all
cls
macro drop _all
set more off


*-------------------------------------------------------
*****************Spatial Beta convergence***************
*-------------------------------------------------------

* NOTE: Requires Stata 15 or higher. See indonesia34withFullDefinitions.dta for data definitions

* TRANSLATE the general shapefile into a stata-format shapefile
spshape2dta indonesia34.shp, replace

* Use and describe the translated shape file
use indonesia34.dta, clear
describe

* SET new ID variable
spset POLY_ID, modify replace
save, replace


* Plot maps
grmap, activate
grmap growth
grmap growth, fcolor(Heat) clmethod(kmeans) clnumber(3) legenda(on) legorder(lohi) legstyle(2) legcount

* Create weight matrix (need Stata>=15)
spmatrix create idistance Widist, normalize(row) replace
spmatrix summarize Widist

* Run the Moran test based on the residuals of an OLS regression
regress growth ln_gd_2001, robust
estat moran, errorlag(Widist)
estat ic

* Fit SLM(SAR) model: spatial lag of the dependent variable
spregress growth ln_gd_2001, ml dvarlag(Widist) vce(robust)
  * Compute information criteria
  estat ic
  * Compute spillover (indirect) effect
  estat impact


* Fit SEM model: spatial lag of the error (no spillover)
spregress growth ln_gd_2001, ml errorlag(Widist) vce(robust)
  * Compute information criteria
  estat ic
  * Compute spillover (indirect) effect
  estat impact
