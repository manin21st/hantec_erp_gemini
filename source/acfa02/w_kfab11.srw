$PBExportHeader$w_kfab11.srw
$PBExportComments$감가상각비 조정처리
forward
global type w_kfab11 from w_inherite
end type
type dw_list from datawindow within w_kfab11
end type
type dw_ip from datawindow within w_kfab11
end type
type cbx_1 from checkbox within w_kfab11
end type
type rr_1 from roundrectangle within w_kfab11
end type
end forward

global type w_kfab11 from w_inherite
string title = "감가상각비 조정처리"
dw_list dw_list
dw_ip dw_ip
cbx_1 cbx_1
rr_1 rr_1
end type
global w_kfab11 w_kfab11

on w_kfab11.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_ip=create dw_ip
this.cbx_1=create cbx_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_kfab11.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_ip)
destroy(this.cbx_1)
destroy(this.rr_1)
end on

event open;call super::open;string sRfgub

lstr_jpra.flag =True

dw_datetime.settransobject(sqlca)
dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)

SELECT MAX("REFFPF"."RFGUB")
 INTO :sRfgub 
 FROM "REFFPF"  
WHERE "REFFPF"."RFCOD" = 'F1'   ;

dw_ip.SetItem(dw_ip.GetRow(), "COMPUTE_YEARMM",String(Today(),"yyyymm"))
dw_ip.SetItem(dw_ip.GetRow(), "KFCOD1","A")
dw_ip.SetItem(dw_ip.GetRow(), "KFCOD2",1)
dw_ip.SetItem(dw_ip.GetRow(), "TFCOD1",sRfgub)
dw_ip.SetItem(dw_ip.GetRow(), "TFCOD2",99999999)

p_mod.Enabled = false 
p_mod.PictureName = "C:\erpman\image\저장_d.gif"

ib_any_typing =False	
CBX_1.CHECKED = TRUE
dw_ip.Setfocus()

end event

type dw_insert from w_inherite`dw_insert within w_kfab11
boolean visible = false
integer x = 82
integer y = 2500
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfab11
boolean visible = false
integer x = 3506
integer y = 3172
end type

type p_addrow from w_inherite`p_addrow within w_kfab11
boolean visible = false
integer x = 3333
integer y = 3172
end type

type p_search from w_inherite`p_search within w_kfab11
boolean visible = false
integer x = 3415
integer y = 2960
end type

type p_ins from w_inherite`p_ins within w_kfab11
boolean visible = false
integer x = 3666
integer y = 3176
end type

type p_exit from w_inherite`p_exit within w_kfab11
end type

type p_can from w_inherite`p_can within w_kfab11
end type

event p_can::clicked;call super::clicked;dw_list.Reset()
dw_ip.SetFocus()
p_mod.Enabled = false 
p_mod.PictureName = "C:\erpman\image\저장_d.gif"
ib_any_typing =False	
end event

type p_print from w_inherite`p_print within w_kfab11
boolean visible = false
integer x = 3589
integer y = 2960
end type

type p_inq from w_inherite`p_inq within w_kfab11
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string  dkfcod1, dtfcod1
long    dkfcod2, dtfcod2, row_num, icount = 0 
string  DCOMPUTE_YEARMM, DKFYEAR, yy, mm, TEMP_YM
decimal skfde01,skfde02,skfde03,skfde04,skfde05,skfde06,skfde07,skfde08,skfde09,skfde10,skfde11,skfde12,dan_amt, &
        skdepval,skdiffval,skfjan01,skfjan02,skfjan03,skfjan04,skfjan05
 		
setpointer(hourglass!)
w_mdi_frame.sle_msg.text =""
dw_ip.AcceptText()
dw_list.Reset()
row_num = dw_ip.GetRow()

dkfcod1  = dw_ip.GetItemString(row_num,"kfcod1")
dtfcod1  = dw_ip.GetItemString(row_num,"tfcod1")
dkfcod2  = dw_ip.GetItemNumber(row_num,"kfcod2")
dtfcod2  = dw_ip.GetItemNumber(row_num,"tfcod2")
DCOMPUTE_YEARMM = dw_ip.GetItemString(row_num,"COMPUTE_YEARMM")

if IsNUll(dkfcod1) then dkfcod1 = ""
if IsNUll(dtfcod1) then dtfcod1 = ""
if IsNUll(dkfcod2) then dkfcod2 = 0
if IsNUll(dtfcod2) then dtfcod2 = 0
if IsNUll(DCOMPUTE_YEARMM) then DCOMPUTE_YEARMM = ""

SELECT "KFA07OM0"."KFYEAR"  
  INTO :DKFYEAR  
  FROM "KFA07OM0"  ;

YY = LEFT(DCOMPUTE_YEARMM,4)
MM = MID(DCOMPUTE_YEARMM, 5 ,2)

if YY <> DKFYEAR Then
   Messagebox("확 인","고정자산 회기년도와 같지 않습니다. !")
   dw_ip.SetFocus()
   dw_ip.SetColumn(3)
   p_mod.Enabled = false 
   p_mod.PictureName = "C:\erpman\image\저장_d.gif"
   return
end if

TEMP_YM = LEFT(DCOMPUTE_YEARMM, 4) + '/' + MID(DCOMPUTE_YEARMM, 5 ,2) + '/' + '01'
if NOT ISDATE(TEMP_YM) Then
   Messagebox("확 인","회계년월이 유효하지 않습니다. !")
   dw_ip.SetFocus()
   dw_ip.SetColumn(3)
   p_mod.Enabled = false 
   p_mod.PictureName = "C:\erpman\image\저장_d.gif"
   return
end if

if dtfcod1 = "" then
   dtfcod1 = dkfcod1 
   dw_ip.SetItem(row_num,"tfcod1",dtfcod1)
end if

if dtfcod2 = 0 then
   dtfcod2 = dkfcod2
   dw_ip.SetItem(row_num,"tfcod2",dtfcod2)
end if

if dkfcod1 > dtfcod1 then
   Messagebox("확 인","고정자산 약칭코드의 범위를 확인하시오. !")
   dw_ip.SetFocus()
   dw_ip.SetColumn(1)
   p_mod.Enabled = false 
   p_mod.PictureName = "C:\erpman\image\저장_d.gif"
   return
else
   if dkfcod1 = dtfcod1 and dkfcod2 > dtfcod2 then
      Messagebox("확 인","고정자산 SEQ의 범위를 확인하시오. !")
      dw_ip.SetFocus()
      dw_ip.SetColumn(2)
      p_mod.Enabled = false 
      p_mod.PictureName = "C:\erpman\image\저장_d.gif"
      return
    end if
end if

dw_list.setredraw(FALSE)

IF dw_list.Retrieve(dkfcod1, dtfcod1, dkfcod2, dtfcod2, yy) < 1 then 
  f_messagechk(11,"") 
  p_mod.Enabled = false 
  p_mod.PictureName = "C:\erpman\image\저장_d.gif"
  Return 
ELSE 
  p_mod.Enabled = True 
  p_mod.PictureName = "C:\erpman\image\저장_up.gif"
END IF

DECLARE save_go CURSOR FOR 
  SELECT "KFA04OM0"."KFDE01", "KFA04OM0"."KFDE02", "KFA04OM0"."KFDE03", "KFA04OM0"."KFDE04",
         "KFA04OM0"."KFDE05", "KFA04OM0"."KFDE06", "KFA04OM0"."KFDE07", "KFA04OM0"."KFDE08",
			"KFA04OM0"."KFDE09", "KFA04OM0"."KFDE10", "KFA04OM0"."KFDE11", "KFA04OM0"."KFDE12",
			"KFA04OM0"."KDEPVAL", "KFA04OM0"."KDIFFVAL", 
			"KFA04OM0"."KFJAN01", "KFA04OM0"."KFJAN02","KFA04OM0"."KFJAN03","KFA04OM0"."KFJAN04","KFA04OM0"."KFJAN05"
    FROM "KFA02OM0",   "KFA04OM0",   "KFA01OM0"  
   WHERE ( "KFA02OM0"."KFCOD1" = "KFA04OM0"."KFCOD1" ) and  
         ( "KFA02OM0"."KFCOD2" = "KFA04OM0"."KFCOD2" ) and  
         ( "KFA02OM0"."KFNYR" = "KFA01OM0"."KFNYR" ) and  
			( "KFA04OM0"."KFYEAR" = :YY ) AND
	      ( "KFA04OM0"."KFCOD1"||"KFA04OM0"."KFCOD2" >= :dkfcod1||:dkfcod2 ) AND
	      ( "KFA04OM0"."KFCOD1"||"KFA04OM0"."KFCOD2" <= :dtfcod1||:dtfcod2 ) 
	ORDER BY "KFA04OM0"."KFCOD1","KFA04OM0"."KFCOD2";
	
OPEN save_go;

	DO WHILE true   
		FETCH save_go 
		INTO :skfde01,:skfde02,:skfde03,:skfde04,:skfde05,:skfde06,:skfde07,:skfde08,
		     :skfde09,:skfde10,:skfde11,:skfde12,:skdepval,:skdiffval,:skfjan01,:skfjan02,:skfjan03,:skfjan04,:skfjan05 ;
		
		  IF SQLCA.SQLCODE <> 0 THEN
      	  exit
   	  END IF
icount = icount + 1 
IF mm = '01' THEN
	dan_amt = skfde01
   dw_list.setitem(icount,"kfa04om0_kfde01", dan_amt)           		
ELSEIF mm = '02' THEN
	dan_amt = skfde01 + skfde02
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", dan_amt)           		
ELSEIF mm = '03' THEN
	dan_amt = skfde01 + skfde02 + skfde03
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", dan_amt)           		   
ELSEIF mm = '04' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 
	dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", dan_amt)           		   
ELSEIF mm = '05' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde05", dan_amt) 
ELSEIF mm = '06' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05 + skfde06 
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde05", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde06", dan_amt) 
ELSEIF mm = '07' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05 + skfde06 + skfde07
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde05", 0)
	dw_list.setitem(icount,"kfa04om0_kfde06", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde07", dan_amt) 
ELSEIF mm = '08' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05 + skfde06 + skfde07 + skfde08 
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde05", 0)
	dw_list.setitem(icount,"kfa04om0_kfde06", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde07", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde08", dan_amt) 
ELSEIF mm = '09' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05 + skfde06 &
	          + skfde07 + skfde08 + skfde09 
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde05", 0)
	dw_list.setitem(icount,"kfa04om0_kfde06", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde07", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde08", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde09", dan_amt) 
ELSEIF mm = '10' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05 + skfde06 &
	          + skfde07 + skfde08 + skfde09 + skfde10 
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde05", 0)
	dw_list.setitem(icount,"kfa04om0_kfde06", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde07", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde08", 0)
	dw_list.setitem(icount,"kfa04om0_kfde09", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde10", dan_amt) 
ELSEIF mm = '11' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05 + skfde06 &
	          + skfde07 + skfde08 + skfde09 + skfde10 + skfde11 
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde05", 0)
	dw_list.setitem(icount,"kfa04om0_kfde06", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde07", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde08", 0)
	dw_list.setitem(icount,"kfa04om0_kfde09", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde10", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde11", dan_amt) 
ELSEIF mm = '12' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05 + skfde06 &
	          + skfde07 + skfde08 + skfde09 + skfde10 + skfde11 + skfde12
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde05", 0)
	dw_list.setitem(icount,"kfa04om0_kfde06", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde07", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde08", 0)
	dw_list.setitem(icount,"kfa04om0_kfde09", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde10", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde11", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde12", dan_amt) 
END IF

   IF cbx_1.checked = true then
       dw_list.setitem(icount,"dan_amt", dan_amt)              //당기상각액
       dw_list.setitem(icount,"imsi_amt", 0)                   //회사상각액
	else
       dw_list.setitem(icount,"dan_amt", dan_amt)              //당기상각액
       dw_list.setitem(icount,"imsi_amt", dan_amt)             //회사상각액
	end if
  LOOP
CLOSE save_go;

dw_list.setredraw(TRUE)
dw_ip.SetFocus()
setpointer(ARROW!)
end event

type p_del from w_inherite`p_del within w_kfab11
boolean visible = false
integer x = 3854
integer y = 3172
end type

type p_mod from w_inherite`p_mod within w_kfab11
integer x = 4096
end type

event p_mod::clicked;call super::clicked;long icount, disrow
decimal iamt, end_count, dan_jan, imsi_jan
string mm, yymm
dw_ip.AcceptText()
dw_list.AcceptText() 

yymm = dw_ip.GetItemString(dw_ip.getrow(),"COMPUTE_YEARMM")
mm = right(yymm, 2)

dw_list.setredraw(false)
end_count = dw_list.getrow()
FOR icount = 1 TO end_count 
    iamt = dw_list.GetitemNumber(icount, "imsi_amt")
    dan_jan = dw_list.GetitemNumber(icount, "dan_jan")
    imsi_jan = dw_list.GetitemNumber(icount, "imsi_jan")
    IF mm = '01' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde01", iamt)           		
    ELSEIF mm = '02' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde02", iamt)           		
    ELSEIF mm = '03' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde03", iamt)           		   
    ELSEIF mm = '04' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde04", iamt)           		   
    ELSEIF mm = '05' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde05", iamt) 
    ELSEIF mm = '06' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde06", iamt) 
    ELSEIF mm = '07' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde07", iamt) 
    ELSEIF mm = '08' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde08", iamt) 
    ELSEIF mm = '09' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde09", iamt) 
    ELSEIF mm = '10' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde10", iamt) 
    ELSEIF mm = '11' THEN
       dw_list.setitem(icount,"kfa04om0_kfde11", iamt) 
    ELSEIF mm = '12' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde12", iamt) 
    END IF
NEXT

IF dw_list.Update() = 1 THEN
   w_mdi_frame.sle_msg.text ="자료를 저장하였습니다.!!!"
	COMMIT;
ELSE
	ROLLBACK;
	f_messagechk(13,"") 
END IF
dw_list.setredraw(true)
ib_any_typing =False	


end event

type cb_exit from w_inherite`cb_exit within w_kfab11
boolean visible = false
integer x = 3127
integer y = 2652
integer width = 398
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_kfab11
boolean visible = false
integer x = 2304
integer y = 2652
integer width = 398
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;long icount, disrow
decimal iamt, end_count, dan_jan, imsi_jan
string mm, yymm
dw_ip.AcceptText()
dw_list.AcceptText() 

yymm = dw_ip.GetItemString(dw_ip.getrow(),"COMPUTE_YEARMM")
mm = right(yymm, 2)

dw_list.setredraw(false)
end_count = dw_list.getrow()
FOR icount = 1 TO end_count 
    iamt = dw_list.GetitemNumber(icount, "imsi_amt")
    dan_jan = dw_list.GetitemNumber(icount, "dan_jan")
    imsi_jan = dw_list.GetitemNumber(icount, "imsi_jan")
    IF mm = '01' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde01", iamt)           		
    ELSEIF mm = '02' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde02", iamt)           		
    ELSEIF mm = '03' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde03", iamt)           		   
    ELSEIF mm = '04' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde04", iamt)           		   
    ELSEIF mm = '05' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde05", iamt) 
    ELSEIF mm = '06' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde06", iamt) 
    ELSEIF mm = '07' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde07", iamt) 
    ELSEIF mm = '08' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde08", iamt) 
    ELSEIF mm = '09' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde09", iamt) 
    ELSEIF mm = '10' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde10", iamt) 
    ELSEIF mm = '11' THEN
       dw_list.setitem(icount,"kfa04om0_kfde11", iamt) 
    ELSEIF mm = '12' THEN
	    dw_list.setitem(icount,"kfa04om0_kfde12", iamt) 
    END IF
NEXT

IF dw_list.Update() = 1 THEN
   sle_msg.text ="자료를 저장하였습니다.!!!"
	COMMIT;
ELSE
	ROLLBACK;
	f_messagechk(13,"") 
END IF
dw_list.setredraw(true)
ib_any_typing =False	


end event

type cb_ins from w_inherite`cb_ins within w_kfab11
boolean visible = false
integer x = 978
integer y = 2920
end type

type cb_del from w_inherite`cb_del within w_kfab11
boolean visible = false
integer x = 1792
integer y = 2920
end type

type cb_inq from w_inherite`cb_inq within w_kfab11
boolean visible = false
integer x = 41
integer y = 2652
integer width = 398
integer taborder = 30
end type

event cb_inq::clicked;string  dkfcod1, dtfcod1
long    dkfcod2, dtfcod2, row_num, icount = 0 
string  DCOMPUTE_YEARMM, DKFYEAR, yy, mm, TEMP_YM
decimal skfde01,skfde02,skfde03,skfde04,skfde05,skfde06,skfde07,skfde08,skfde09,skfde10,skfde11,skfde12,dan_amt, &
        skdepval,skdiffval,skfjan01,skfjan02,skfjan03,skfjan04,skfjan05
 		
setpointer(hourglass!)
sle_msg.text =""
dw_ip.AcceptText()
dw_list.Reset()
row_num = dw_ip.GetRow()

dkfcod1  = dw_ip.GetItemString(row_num,"kfcod1")
dtfcod1  = dw_ip.GetItemString(row_num,"tfcod1")
dkfcod2  = dw_ip.GetItemNumber(row_num,"kfcod2")
dtfcod2  = dw_ip.GetItemNumber(row_num,"tfcod2")
DCOMPUTE_YEARMM = dw_ip.GetItemString(row_num,"COMPUTE_YEARMM")

if IsNUll(dkfcod1) then dkfcod1 = ""
if IsNUll(dtfcod1) then dtfcod1 = ""
if IsNUll(dkfcod2) then dkfcod2 = 0
if IsNUll(dtfcod2) then dtfcod2 = 0
if IsNUll(DCOMPUTE_YEARMM) then DCOMPUTE_YEARMM = ""

SELECT "KFA07OM0"."KFYEAR"  
  INTO :DKFYEAR  
  FROM "KFA07OM0"  ;

YY = LEFT(DCOMPUTE_YEARMM,4)
MM = MID(DCOMPUTE_YEARMM, 5 ,2)

if YY <> DKFYEAR Then
   Messagebox("확 인","고정자산 회기년도와 같지 않습니다. !")
   dw_ip.SetFocus()
   dw_ip.SetColumn(3)
   cb_mod.Enabled = False
   return
end if

TEMP_YM = LEFT(DCOMPUTE_YEARMM, 4) + '/' + MID(DCOMPUTE_YEARMM, 5 ,2) + '/' + '01'
if NOT ISDATE(TEMP_YM) Then
   Messagebox("확 인","회계년월이 유효하지 않습니다. !")
   dw_ip.SetFocus()
   dw_ip.SetColumn(3)
   cb_mod.Enabled = False
   return
end if

if dtfcod1 = "" then
   dtfcod1 = dkfcod1 
   dw_ip.SetItem(row_num,"tfcod1",dtfcod1)
end if

if dtfcod2 = 0 then
   dtfcod2 = dkfcod2
   dw_ip.SetItem(row_num,"tfcod2",dtfcod2)
end if

if dkfcod1 > dtfcod1 then
   Messagebox("확 인","고정자산 약칭코드의 범위를 확인하시오. !")
   dw_ip.SetFocus()
   dw_ip.SetColumn(1)
   cb_mod.Enabled = False
   return
else
   if dkfcod1 = dtfcod1 and dkfcod2 > dtfcod2 then
      Messagebox("확 인","고정자산 SEQ의 범위를 확인하시오. !")
      dw_ip.SetFocus()
      dw_ip.SetColumn(2)
      cb_mod.Enabled = False
      return
    end if
end if

dw_list.setredraw(FALSE)

IF dw_list.Retrieve(dkfcod1, dtfcod1, dkfcod2, dtfcod2, yy) < 1 then 
  f_messagechk(11,"") 
  cb_mod.Enabled = False
  Return 
ELSE 
  cb_mod.Enabled = True
END IF

DECLARE save_go CURSOR FOR 
  SELECT "KFA04OM0"."KFDE01", "KFA04OM0"."KFDE02", "KFA04OM0"."KFDE03", "KFA04OM0"."KFDE04",
         "KFA04OM0"."KFDE05", "KFA04OM0"."KFDE06", "KFA04OM0"."KFDE07", "KFA04OM0"."KFDE08",
			"KFA04OM0"."KFDE09", "KFA04OM0"."KFDE10", "KFA04OM0"."KFDE11", "KFA04OM0"."KFDE12",
			"KFA04OM0"."KDEPVAL", "KFA04OM0"."KDIFFVAL", 
			"KFA04OM0"."KFJAN01", "KFA04OM0"."KFJAN02","KFA04OM0"."KFJAN03","KFA04OM0"."KFJAN04","KFA04OM0"."KFJAN05"
    FROM "KFA02OM0",   "KFA04OM0",   "KFA01OM0"  
   WHERE ( "KFA02OM0"."KFCOD1" = "KFA04OM0"."KFCOD1" ) and  
         ( "KFA02OM0"."KFCOD2" = "KFA04OM0"."KFCOD2" ) and  
         ( "KFA02OM0"."KFNYR" = "KFA01OM0"."KFNYR" ) and  
			( "KFA04OM0"."KFYEAR" = :YY ) AND
	      ( "KFA04OM0"."KFCOD1"||"KFA04OM0"."KFCOD2" >= :dkfcod1||:dkfcod2 ) AND
	      ( "KFA04OM0"."KFCOD1"||"KFA04OM0"."KFCOD2" <= :dtfcod1||:dtfcod2 ) 
	ORDER BY "KFA04OM0"."KFCOD1","KFA04OM0"."KFCOD2";
	
OPEN save_go;

	DO WHILE true   
		FETCH save_go 
		INTO :skfde01,:skfde02,:skfde03,:skfde04,:skfde05,:skfde06,:skfde07,:skfde08,
		     :skfde09,:skfde10,:skfde11,:skfde12,:skdepval,:skdiffval,:skfjan01,:skfjan02,:skfjan03,:skfjan04,:skfjan05 ;
		
		  IF SQLCA.SQLCODE <> 0 THEN
      	  exit
   	  END IF
icount = icount + 1 
IF mm = '01' THEN
	dan_amt = skfde01
   dw_list.setitem(icount,"kfa04om0_kfde01", dan_amt)           		
ELSEIF mm = '02' THEN
	dan_amt = skfde01 + skfde02
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", dan_amt)           		
ELSEIF mm = '03' THEN
	dan_amt = skfde01 + skfde02 + skfde03
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", dan_amt)           		   
ELSEIF mm = '04' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 
	dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", dan_amt)           		   
ELSEIF mm = '05' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde05", dan_amt) 
ELSEIF mm = '06' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05 + skfde06 
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde05", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde06", dan_amt) 
ELSEIF mm = '07' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05 + skfde06 + skfde07
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde05", 0)
	dw_list.setitem(icount,"kfa04om0_kfde06", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde07", dan_amt) 
ELSEIF mm = '08' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05 + skfde06 + skfde07 + skfde08 
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde05", 0)
	dw_list.setitem(icount,"kfa04om0_kfde06", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde07", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde08", dan_amt) 
ELSEIF mm = '09' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05 + skfde06 &
	          + skfde07 + skfde08 + skfde09 
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde05", 0)
	dw_list.setitem(icount,"kfa04om0_kfde06", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde07", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde08", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde09", dan_amt) 
ELSEIF mm = '10' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05 + skfde06 &
	          + skfde07 + skfde08 + skfde09 + skfde10 
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde05", 0)
	dw_list.setitem(icount,"kfa04om0_kfde06", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde07", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde08", 0)
	dw_list.setitem(icount,"kfa04om0_kfde09", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde10", dan_amt) 
ELSEIF mm = '11' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05 + skfde06 &
	          + skfde07 + skfde08 + skfde09 + skfde10 + skfde11 
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde05", 0)
	dw_list.setitem(icount,"kfa04om0_kfde06", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde07", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde08", 0)
	dw_list.setitem(icount,"kfa04om0_kfde09", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde10", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde11", dan_amt) 
ELSEIF mm = '12' THEN
	dan_amt = skfde01 + skfde02 + skfde03 + skfde04 + skfde05 + skfde06 &
	          + skfde07 + skfde08 + skfde09 + skfde10 + skfde11 + skfde12
   dw_list.setitem(icount,"kfa04om0_kfde01", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde02", 0)           		
   dw_list.setitem(icount,"kfa04om0_kfde03", 0)           		   
   dw_list.setitem(icount,"kfa04om0_kfde04", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde05", 0)
	dw_list.setitem(icount,"kfa04om0_kfde06", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde07", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde08", 0)
	dw_list.setitem(icount,"kfa04om0_kfde09", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde10", 0) 
   dw_list.setitem(icount,"kfa04om0_kfde11", 0) 
	dw_list.setitem(icount,"kfa04om0_kfde12", dan_amt) 
END IF

   IF cbx_1.checked = true then
       dw_list.setitem(icount,"dan_amt", dan_amt)              //당기상각액
       dw_list.setitem(icount,"imsi_amt", 0)                   //회사상각액
	else
       dw_list.setitem(icount,"dan_amt", dan_amt)              //당기상각액
       dw_list.setitem(icount,"imsi_amt", dan_amt)             //회사상각액
	end if
  LOOP
CLOSE save_go;

dw_list.setredraw(TRUE)
dw_ip.SetFocus()
setpointer(ARROW!)
end event

type cb_print from w_inherite`cb_print within w_kfab11
integer x = 1349
integer y = 2920
end type

type st_1 from w_inherite`st_1 within w_kfab11
end type

type cb_can from w_inherite`cb_can within w_kfab11
boolean visible = false
integer x = 2715
integer y = 2652
integer width = 398
integer taborder = 50
end type

event cb_can::clicked;call super::clicked;dw_list.Reset()
dw_ip.SetFocus()
cb_mod.Enabled = false 
ib_any_typing =False	
end event

type cb_search from w_inherite`cb_search within w_kfab11
integer x = 2199
integer y = 2920
end type







type gb_button1 from w_inherite`gb_button1 within w_kfab11
boolean visible = false
integer x = 9
integer y = 2596
integer width = 457
end type

type gb_button2 from w_inherite`gb_button2 within w_kfab11
boolean visible = false
integer x = 2267
integer y = 2596
integer width = 1289
end type

type dw_list from datawindow within w_kfab11
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 184
integer width = 4498
integer height = 2136
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_kfab11_2"
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_any_typing =True
end event

event itemchanged;decimal dimsi_amt, ddepval, dkfjan01, dkfjan03

dw_list.AcceptText()
ddepval   = dw_list.GetitemNumber(dw_list.getrow(), "kfa04om0_kdepval")
dimsi_amt = dw_list.GetitemNumber(dw_list.getrow(), "imsi_amt")
dkfjan01  = dw_list.GetitemNumber(dw_list.getrow(), "kfa04om0_kfjan01")
dkfjan03  = dw_list.GetitemNumber(dw_list.getrow(), "kfa04om0_kfjan03")
IF ddepval < dimsi_amt then  //상각부인액//
   dw_list.setitem(dw_list.getrow(),"kfa04om0_kdiffval", dimsi_amt - ddepval) 
   dw_list.setitem(dw_list.getrow(),"kfa04om0_kfjan05", 0) 
end if
IF ddepval > dimsi_amt then  //시인부족액//
   dw_list.setitem(dw_list.getrow(),"kfa04om0_kfjan05", ddepval - dimsi_amt) 
   dw_list.setitem(dw_list.getrow(),"kfa04om0_kdiffval", 0) 
end if
IF ddepval = dimsi_amt then  //세법과일치//
   dw_list.setitem(dw_list.getrow(),"kfa04om0_kfjan05", 0) 
   dw_list.setitem(dw_list.getrow(),"kfa04om0_kdiffval", 0) 
end if
if (dkfjan01 > 0) and (ddepval > dimsi_amt) then  //기왕부인액중 시인부족액 범위내에서 손금추인처리//
   if dkfjan01 > (ddepval - dimsi_amt) then       //전기상각부인액 > 당기시인부족액, 시인부족액을//
	   dw_list.setitem(dw_list.getrow(),"kfa04om0_kfjan03", ddepval - dimsi_amt) 
	elseif dkfjan01 < (ddepval - dimsi_amt) then   //전기상각부인액 < 당기시인부족액, 전기상각부인액을//
	   dw_list.setitem(dw_list.getrow(),"kfa04om0_kfjan03", dkfjan01) 
	else                                           //전기상각부인액 = 당기시인부족액, 전기상각부인액을//
	   dw_list.setitem(dw_list.getrow(),"kfa04om0_kfjan03", dkfjan01) 
	end if
ELSE
   dw_list.setitem(dw_list.getrow(),"kfa04om0_kfjan03", 0) 
end if
end event

type dw_ip from datawindow within w_kfab11
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 46
integer y = 24
integer width = 2578
integer height = 120
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kfab11_1"
boolean border = false
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;char dkfcod1
long dkfcod2, row_num, retrieve_row 

SetNull(gs_code)
SetNull(gs_codename)

dw_ip.AcceptText()

IF this.GetColumnName() ="kfcod2" THEN 	
	row_num  = dw_ip.Getrow()

	dkfcod1 = dw_ip.GetItemString( row_num, "kfcod1")
	dkfcod2 = dw_ip.GetItemNumber( row_num, "kfcod2")

	IF Isnull(dkfcod1) then dkfcod1 = ""
	if Isnull(dkfcod2) then dkfcod2 = 0

	gs_code = dkfcod1
	gs_codename = String(dkfcod2)

	open(w_kfaa02b)
	
	IF IsNull(gs_code) THEN RETURN
	
   dw_ip.setitem(dw_ip.Getrow(),"kfcod1",gs_code)
   dw_ip.Setitem(dw_ip.Getrow(),"kfcod2",Long(gs_codename))
END IF

IF this.GetColumnName() ="tfcod2" THEN 	
	row_num  = dw_ip.Getrow()

	dkfcod1 = dw_ip.GetItemString( row_num, "tfcod1")
	dkfcod2 = dw_ip.GetItemNumber( row_num, "tfcod2")

	IF Isnull(dkfcod1) then dkfcod1 = ""
	if Isnull(dkfcod2) then dkfcod2 = 0

	gs_code = dkfcod1
	gs_codename = String(dkfcod2)

	open(w_kfaa02b)
	
	IF IsNull(gs_code) THEN RETURN
	
   dw_ip.setitem(dw_ip.Getrow(),"tfcod1",gs_code)
   dw_ip.Setitem(dw_ip.Getrow(),"tfcod2",Long(gs_codename))
END IF

dw_ip.setfocus()


end event

type cbx_1 from checkbox within w_kfab11
integer x = 2629
integer y = 52
integer width = 1083
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "세법상 상각액을 초기화후 표시"
boolean lefttext = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kfab11
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 180
integer width = 4581
integer height = 2152
integer cornerheight = 40
integer cornerwidth = 46
end type

