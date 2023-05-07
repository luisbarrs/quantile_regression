/*******************************************************************************
  Research:
  "Heterogeneidad en trabajadores independientes y brecha en sus ingresos según 
  el género en el Perú rural, 2019-2021"
  "Heterogeneity in self-employed workers and gap in their income according to 
  gender in rural Peru, 2019-2021"
  Author: Bach. Luis Enrique Barriga Sairitupa
*******************************************************************************/

********************************************************************************
*  1.  Initial setup and installation of required packages
********************************************************************************
  * 1.1 Set the forwking folder
  cd "D:"                       // It can be change for another place
  * Download data base of GitHub url
  copy "https://github.com/luisbarrs/quantile_regression/raw/main/panel_data_2019_2021.dta" "panel_data_2019_2021.dta",replace  
  
  * 1.2 Installation of required packages
  local packages moremata mdqr xtmdqr 
  net install mdqr, from("https://sites.google.com/site/mellyblaise/")
  net install xtmdqr, from("https://sites.google.com/site/mellyblaise/")
  net install qrprocess, from("https://sites.google.com/site/mellyblaise/")
  ssc install moremata
  
  * Use the data panel 2019_2021    
  use "D:/panel_data_2019_2021.dta",clear 
  xtset numper year
  tab act_, nofreq generate(ac_)
  tab marital_s_, nofreq generate(ms_)                       
  global var_x ///
          antiquity_ antiquity2_ informal_ ac_1 ms_1    
  
  * Fixed effects 
  local i = 1
  local quantil = "0.1 0.25 0.5 0.75 0.9"
  foreach qr in `quantil' {
    eststo reg`i': xtmdqr l_income_ $var_x, fe quantile(`qr')
    local ++i
  }

  * Between effects
  local i = 6
  local quantil = "0.1 0.25 0.5 0.75 0.9"
  foreach qr in `quantil' {
    eststo reg`i': xtmdqr l_income_ $var_x, be quantile(`qr')
    local ++i
  }
  
  * Random effects
  local i = 11
  local quantil = "0.1 0.25 0.5 0.75 0.9"
  foreach qr in `quantil' {
    eststo reg`i': xtmdqr l_income_ $var_x, re quantile(`qr')
    local ++i
  }      

  
  /* Settings for tables for exportation to Tex
  global style  "label nolines nogaps fragment nomtitle nonumbers nodep star(* 0.10 ** 0.05 *** 0.01) collabels(none) booktabs b(3) se(3)"
  global style1 "label fragment nomtitle nonumbers nodep star(* 0.10 ** 0.05 *** 0.01) collabels(none) booktabs b(3) se(3)"
  
  * Exportation Fixed effects
  global quant_1 ///
          reg1 reg2 reg3 reg4 reg5
  esttab $quant_1 using "${data_2019_2021_3}/q_reg_1.tex",  ///
      replace ${style1}

  * Exportation Between effects   
  global quant_2 ///
          reg6 reg7 reg8 reg9 reg10
  esttab $quant_2 using "${data_2019_2021_3}/q_reg_2.tex", ///
      replace ${style1}

  * Exportation Random effects
  global quant_3 ///
          reg11 reg12 reg13 reg14 reg15
  esttab $quant_3 using "${data_2019_2021_3}/q_reg_3.tex", ///
      replace ${style1}
        