*create perm library;
/*libname CCD "C:\Users\ivanon1\Desktop\CCD_school_Geo_Code\EDGE_GEOCODE_PUBLICSCH_1516"; run;*/

/*  Specify a location in your file system   */
filename odsout '/home/ivanon10/sasuser.v94';

 /* Close the listing destination.  */
 ods listing close;

*Create GeoCode dataset for state of Nevada from common core geographic dataset;
data geocode_nv;
set work.IMPORT;
if LSTATE='NV';
Keep CNTY15 LAT1516 LON1516 NAME NMCNTY15 LSTATE LZIP LSTREE OPSTFIPS;
rename LAT1516 = Y LON1516 = X LZIP = ZIP;
run; 

/*Create format for county level codes*/
proc format library= work;
value FMTCOUNTY
	1= '32001'
	3= '32003'
	5='32005'
	7= '32007'
	9= '32009'
	11='32011'
	13='32013'
	15='32015'
	17='32017'
	19='32019'
    21='32021'
	23='32023'
	27='32027'
    29='32029'
    31='32031'
	33='32033'
	510='32510';
	run;
options fmtsearch = (work.formats);

/*Create data step to apply format and generate html variables in my data source*/
Data Geocode_Nv2;
set Geocode_Nv;
if cnty15 = 32001 then county = 1;
else if cnty15 = 32003 then county=3;
else if cnty15 = 32005 then county=5;
else if cnty15 = 32007 then county=7;
else if cnty15 = 32009 then county=9;
else if cnty15 = 32011 then county=11;
else if cnty15 = 32013 then county=13;
else if cnty15 = 32015 then county=15;
else if cnty15 = 32017 then county=17;
else if cnty15 = 32019 then county=19;
else if cnty15 = 32021 then county=21;
else if cnty15 = 32023 then county=23;
else if cnty15 = 32027 then county=27;
else if cnty15 = 32029 then county=29;
else if cnty15 = 32031 then county=31;
else if cnty15 = 32033 then county=33;
else if cnty15 = 32510 then county=510;
format county FMTCOUNTY.;


/* The HTML variable. */
   length htmlvar $1024.;

/* Assign values to HTML variables. */
    if NMCNTY15 = 'Clark County' then
          htmlvar = 'href="Clark.htm"';
       else if NMCNTY15 = 'Carson City' then
            htmlvar = 'href="Carson.htm"';
       else if NMCNTY15 = 'Washoe County' then 
            htmlvar = 'href="washoe.htm"';
	   else if NMCNTY15 = 'Churchill County' then
	   		htmlvar = 'href= "Churchill.htm"';
	   else if NMCNTY15 = 'Douglas County' then
	   		htmlvar = 'href= "Douglas.htm"';
	   else if NMCNTY15 = 'Elko County' then
	   		htmlvar = 'href= "Elko.htm"';
	   else if NMCNTY15 = 'Esmeralda County' then
	   		htmlvar = 'href= "Esmeralda.htm"';
	   else if NMCNTY15 = 'Eureka County' then
	   		htmlvar = 'href= "Eureka.htm"';
	   else if NMCNTY15 = 'Humboldt County' then
	   		htmlvar = 'href= "Humboldt.htm"';
	   else if NMCNTY15 = 'Lander County' then
	   		htmlvar = 'href= "Lander.htm"';
	   else if NMCNTY15 = 'Lincoln County' then
	   		htmlvar = 'href= "Lincoln.htm"';
	   else if NMCNTY15 = 'Lyon County' then
	   		htmlvar = 'href= "Lyon.htm"';
	   else if NMCNTY15 = 'Mineral County' then
	   		htmlvar = 'href= "Mineral.htm"';
	   else if NMCNTY15 = 'Nye County' then
	   		htmlvar = 'href= "Nye.htm"';
	   else if NMCNTY15 = 'Pershing County' then
	   		htmlvar = 'href= "Pershing.htm"';
	   else if NMCNTY15 = 'Storey County' then
	   		htmlvar = 'href= "Storey.htm"';
	   else if NMCNTY15 = 'White Pine County' then
	   		htmlvar = 'href= "White_Pine.htm"';
run;

*Macro to generate county level datasets;
%macro county(data=, county=);
	
	data &data;
	set Geocode_nv(obs=2);
	state = 32;
	where cnty15 = "&county."; 
	run;	
%mend county;
%county (data=Counties1, county=32003) ;
%county (data=Counties2, county=32017) ;
%county (data=Counties3, county=32510) ;
%county (data=Counties4, county=32031) ;
%county (data=Counties5, county=32001) ;
%county (data=Counties6, county=32005) ;
%county (data=Counties7, county=32007) ;
%county (data=Counties8, county=32009) ;
%county (data=Counties9, county=32011) ;
%county (data=Counties10, county=32013) ;
%county (data=Counties11, county=32015) ;
%county (data=Counties12, county=32019) ;
%county (data=Counties13, county=32021) ;
%county (data=Counties14, county=32023) ;
%county (data=Counties15, county=32027) ;
%county (data=Counties16, county=32029) ;
%county (data=Counties17, county=32033) ;

/*Macro for applying annotations to each county data source*/
%MACRO Annoset(data = , county= );

/* Create an annotate data set to label   */
/* the school locations with the school names */
* Create the annotate data set for school names in each county. ;
  data &data;
	set Geocode_nv(obs=2);
	state = 32;
	where cnty15 = "&county."; 

 length function style color $ 8 position $ 1 text $ 20 html $1024;
 retain xsys ysys '2' hsys '3' when 'a' text '';
 
 /* Create a tool-tip and Drill down for the dot */
 html=
 'alt='||
 quote(
 'School Name: '||trim(left(name))||' '
 ) || ' '||
 'href="'||trim(left(lowcase(name)))||'.html" target=_NEW_'
 ;
 color='black'; size=.7; rotate=360; style='Marker'; text='V';
 position='5';
 output;
run; 

%mend Annoset;
%Annoset (data=cname1, county=32003) ;
%Annoset (data=cname2, county=32017) ;
%Annoset (data=cname3, county=32510) ;
%Annoset (data=cname4, county=32031) ;
%Annoset (data=cname5, county=32001) ;
%Annoset (data=cname6, county=32005) ;
%Annoset (data=cname7, county=32007) ;
%Annoset (data=cname8, county=32009) ;
%Annoset (data=cname9, county=32011) ;
%Annoset (data=cname10, county=32013) ;
%Annoset (data=cname11, county=32015) ;
%Annoset (data=cname12, county=32019) ;
%Annoset (data=cname13, county=32021) ;
%Annoset (data=cname14, county=32023) ;
%Annoset (data=cname15, county=32027) ;
%Annoset (data=cname16, county=32029) ;
%Annoset (data=cname17, county=32033) ;

* Set Options for gif Driver;
*Note I use the gif Driver for the original County Maps;
goptions
reset=all
device=gif
xpixels=1024
ypixels=768;

*select Nevada (state number 32) from the MAPS.COUNTIES map data set;
proc gproject data=maps.counties out=nv asis;
where state eq 32;
id county;
run;

/* Open the HTML destination for ODS output. */
ods html body = 'NevadaMaps.htm' 
         path = odsout;

* Create County Level Map that uses html var;
title1 'Nevada County Map';
proc gmap
map=nv
data=Geocode_Nv2
;
id county;
choro NMCNTY15 / discrete coutline=black
 html=htmlvar;
 run;
 quit;

 
/* Macro to Project the annotate datasets to match the MAPSGFK.US_STATE map data set */
/*Note we must project the annotated datasets before they can be used in the proc gmap procedure later on*/
%macro projected (num=);
proc gproject data=cname&num out=anno&num dupok  
     parmin=mapsgfk.projparm parmentry=us_counties;
   id state;
run;
%mend projected;
%projected (num=1);
%projected (num=2);
%projected (num=3);
%projected (num=4);
%projected (num=5);
%projected (num=6);
%projected (num=7);
%projected (num=8);
%projected (num=9);
%projected (num=10);
%projected (num=11);
%projected (num=12);
%projected (num=13);
%projected (num=14);
%projected (num=15);
%projected (num=16);
%projected (num=17);

/*Macro to generate data source for each county from maps us_counties dataset*/
/*Note these datasets will be used in the proc gmap parameters when we project our county level maps*/
%MACRO MapState (data = , code = );
data &data;
   set Mapsgfk.us_counties;
   where state=32
   and county = &code; 
run;

%mend MapState;
%MapState (data=state1, code=3) ;
%MapState (data=state2, code=17) ;
%MapState (data=state3, code=510) ;
%MapState (data=state4, code=31) ;
%MapState (data=state5, code=1) ;
%MapState (data=state6, code=5) ;
%MapState (data=state7, code=7) ;
%MapState (data=state8, code=9) ;
%MapState (data=state9, code=11) ;
%MapState (data=state10, code=13) ;
%MapState (data=state11, code=15) ;
%MapState (data=state12, code=19) ;
%MapState (data=state13, code=21) ;
%MapState (data=state14, code=23) ;
%MapState (data=state15, code=27) ;
%MapState (data=state16, code=29) ;
%MapState (data=state17, code=33) ;

/*Set options to activex driver for the drill down county level maps to enable interactivity*/
goptions
reset=all
device=activex
xpixels=1024
ypixels=768;

/*Macro to generate html drill down body reports for each county using tool tips and interactivity on maps*/
%macro ActiveMapper(nums =, names =, htmlfiles= ,modfile= , title =, colors =);

*Drill Down Tips on county map;
 data counties&nums; /* add to the response*/
 length htmlvar $1024; /* Make sure it is long enough */
 state=32;
 do name = "&names." ;
 /*take only valid names*/
 if name ^= '' then do;
 htmlvar= 'alt='||quote( trim(left('Name: '||
 trim(left((name))) ))) ||
 'href='||quote('https://ccsd.net/'|| 
 trim(left(name))) ||
 'target=_new_'
 ;
 output;
 end;
 end;
 run; 

/* Open a body file for report on each county. */

 ods html body = "&htmlfiles..htm"
          parameters=("DRILLDOWNMODE"="Script"
                 "EXTERNALNAME"="GIDX"
                 "DRILLTARGET"="_self"
                 "DRILLFUNC"="MapDrill"
                  "ZoomControlEnabled"="True")
     attributes=("NAME"="GIDX")
         path = odsout;

 title1 "&title.";
 pattern1 v=s color = "&colors.";
proc gmap map=state&nums data=counties&nums;
   id State;
   choro name / discrete anno=anno&nums html= htmlvar nolegend;
run;
quit;

data _null_ ;
file "&modfile..htm" mod; /* modify rather than replace file */
  put " " ;
  put "<SCRIPT LANGUAGE='JavaScript'>" ;
  put "function MapDrill( appletref )" ;
  put "{" ;
  put " " ;
  put "/* Open an alert box to show the abbreviated  name. */" ;
  put "for(i = 2; i < MapDrill.arguments.length; i += 2 )" ;
  put "  {" ;
  put "    if (MapDrill.arguments[i] == 'G_DEPV,f' ) " ;
  put "        alert(MapDrill.arguments[i+1]);" ;
  put "  }" ;
  put " " ;
  put "}" ;
  put "</SCRIPT>";
run ;

%mend ActiveMapper;
%ActiveMapper (nums = 1, names = Clark County Map, htmlfiles = Clark, title = Clark County Schools,modfile = Clark,colors =CX20B2AA ) ;
%ActiveMapper (nums = 2, names = Lincoln County Map, htmlfiles = Lincoln, title = Lincoln County Schools,modfile = Lincoln,colors=cx91CF60 ) ;
%ActiveMapper (nums = 3, names = Carson City County Map, htmlfiles = Carson, title = Carson City County Schools,modfile = Carson,colors= CX4682B4) ;
%ActiveMapper (nums = 4, names = Washoe County Map, htmlfiles = Washoe, title = Washoe County Schools,modfile = Washoe, colors= CX8B4513) ;
%ActiveMapper (nums = 5, names = Churchill County Map, htmlfiles = Churchill, title = Churchill County Schools,modfile = Churchill,colors=CXCD5C5C ) ;
%ActiveMapper (nums = 6, names = Douglas County Map, htmlfiles = Douglas, title = Douglas County Schools,modfile = Douglas,colors= CXA0522D) ;
%ActiveMapper (nums = 7, names = Elko County Map, htmlfiles = Elko, title = Elko County Schools,modfile = Elko,colors=CXBA55D3 ) ;
%ActiveMapper (nums = 8, names = Esmeralda County Map, htmlfiles = Esmeralda, title = Esmeralda County Schools,modfile = Esmeralda,colors=CXDAA520 ) ;
%ActiveMapper (nums = 9, names = Eureka County Map, htmlfiles = Eureka, title = Eureka County Schools,modfile = Eureka, colors=CX00BFFF ) ;
%ActiveMapper (nums = 10, names = Humboldt County Map, htmlfiles = Humboldt, title = Humboldt County Schools,modfile = Humboldt, colors= CXDB7093) ;
%ActiveMapper (nums = 11, names = Lander County Map, htmlfiles = Lander, title = Lander County Schools,modfile = Lander, colors=CXFF8C00 ) ;
%ActiveMapper (nums = 12, names = Lyon County Map, htmlfiles = Lyon, title = Lyon County Schools,modfile = Lyon,colors=CXB0E0E6 ) ;
%ActiveMapper (nums = 13, names = Mineral County Map, htmlfiles = Mineral, title = Mineral County Schools,modfile = Mineral,colors=CXFFD700 ) ;
%ActiveMapper (nums = 14, names = Nye County Map, htmlfiles = Nye, title = Nye County Schools,modfile = Nye,colors=CX00008B ) ;
%ActiveMapper (nums = 15, names = Pershing County Map, htmlfiles = Pershing, title = Pershing County Schools,modfile = Pershing,colors=CX8B0000 ) ;
%ActiveMapper (nums = 16, names = Storey County Map, htmlfiles = Storey, title = Storey County Schools,modfile = Storey,colors= CX2F4F4F) ;
%ActiveMapper (nums = 17, names = White Pine County Map, htmlfiles = White Pine, title = White Pine County Schools,modfile = White Pine,colors= CX8B008B) ;

 /* Close the HTML destination. */
 ods html close;
 /* Open the listing destination. */
 ods listing;

 goptions reset=all;
 filename odsout clear;



