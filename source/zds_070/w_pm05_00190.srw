$PBExportHeader$w_pm05_00190.srw
$PBExportComments$일일생산계획대비실적현황
forward
global type w_pm05_00190 from w_standard_print
end type
type rr_1 from roundrectangle within w_pm05_00190
end type
type rr_2 from roundrectangle within w_pm05_00190
end type
end forward

global type w_pm05_00190 from w_standard_print
integer height = 2540
string title = "일일생산계획대비실적현황"
rr_1 rr_1
rr_2 rr_2
end type
global w_pm05_00190 w_pm05_00190

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sDate,sSaupj, sJdat, sMdat1, sMdat2, sItcls, sIttyp
String ls_dategub

if 	dw_ip.AcceptText() = -1 then return -1

sDate  	= dw_ip.GetItemString(1,"jidat")  
ssaupj  	= dw_ip.GetItemString(1,"saupj")
sIttyp  	= dw_ip.GetItemString(1,"ittyp")
sItcls  	= dw_ip.GetItemString(1,"itcls")
 
if	f_datechk(sDate) = -1 then
	f_message_chk(35,'[기준일자]')
	dw_ip.SetColumn("jidat")
	dw_ip.SetFocus()
	return -1
end if 

if sIttyp = '2' then
  dw_list.dataobject 	= "d_pm05_00190_2"
  dw_print.dataobject 	= "d_pm05_00190_2p"	
Else
  dw_list.dataobject 	= "d_pm05_00190"
  dw_print.dataobject 	= "d_pm05_00190_p"
End if
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

SELECT to_char(to_date(:sdate,'yyyymmdd')-1,'yyyymmdd'),
		to_char(to_date(:sdate,'yyyymmdd')+1,'yyyymmdd'),
		to_char(to_date(:sdate,'yyyymmdd')+2,'yyyymmdd')
 INTO :sJdat , :sMdat1, :sMdat2
 FROM dual;
if sItcls = '' or isNull(sItcls) or sItcls = '  ' then sItcls = '%'

IF dw_print.Retrieve(gs_sabu, ssaupj, sJdat, sDate, sItcls + '%') < 1 THEN
  	f_message_chk(50,'')
  	return -1
END IF

dw_print.object.t_sdate.text = left(sDate,4) + '.' + mid(sDate,5,2) + '.' + mid(sDate,7,2) 
dw_print.object.t_d1.text = mid(sdate,5,2) + '.' + mid(sdate,7,2) 
dw_print.object.t_j1.text = mid(sJdat,5,2) + '.' + mid(sJdat,7,2) 
dw_print.object.t_j2.text = mid(sJdat,5,2) + '.' + mid(sJdat,7,2) 
dw_print.object.t_m1.text = mid(sMdat1,5,2) + '.' + mid(sMdat1,7,2) 
dw_print.object.t_m2.text = mid(sMdat2,5,2) + '.' + mid(sMdat2,7,2) 
dw_print.sharedata(dw_list)
return 1
end function

on w_pm05_00190.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_pm05_00190.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
/* User별 사업장 Setting */
setnull(gs_code)

dw_ip.SetItem(1,"jidat",F_today())


end event

type p_preview from w_standard_print`p_preview within w_pm05_00190
end type

type p_exit from w_standard_print`p_exit within w_pm05_00190
end type

type p_print from w_standard_print`p_print within w_pm05_00190
end type

type p_retrieve from w_standard_print`p_retrieve within w_pm05_00190
end type







type st_10 from w_standard_print`st_10 within w_pm05_00190
end type

type gb_10 from w_standard_print`gb_10 within w_pm05_00190
boolean visible = false
integer x = 155
integer y = 2764
integer height = 152
integer textsize = -12
fontcharset fontcharset = defaultcharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type dw_print from w_standard_print`dw_print within w_pm05_00190
integer x = 3502
integer y = 116
string dataobject = "d_pm05_00190_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pm05_00190
integer x = 55
integer y = 64
integer width = 2437
integer height = 184
string dataobject = "d_pm05_00190_1"
end type

event dw_ip::rbuttondown;string sName

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

Choose  Case	this.GetColumnName()
	Case 	"itcls"	// 품목분류 from.
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
	
    lstr_sitnct = Message.PowerObjectParm	
	
	 IF lstr_sitnct.s_ittyp ="" OR IsNull(lstr_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",lstr_sitnct.s_sumgub)
	 this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",  lstr_sitnct.s_ittyp)
	 
END Choose
end event

event dw_ip::itemchanged;string swkctr, swknm, swknm2 , ls_date, sCode, sName, sOther, smatchk, spdsts,sItemCls,sItemGbn,sItemClsName
int    ireturn 

Choose  Case	this.GetColumnName()
	Case 	"ittyp"	
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 
			this.SetItem(1,"ittyp",'1')
		End if
		IF sItemCls = "1" OR sItemCls = "2"  THEN
		Else
			this.SetItem(1,"ittyp",'1')
		End if
		
	Case 	"itcls"	// 품목분류 from.
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = this.GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			
			SELECT "ITNCT"."TITNM"  	INTO :sItemClsName  
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
				
			IF SQLCA.SQLCODE <> 0 THEN
				this.TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				this.SetItem(1,"itclsnm",sItemClsName)
			END IF
		END IF
	Case 	"jidat" , "jidat1"                  	//.
		  ls_date = this.gettext()
		  if 		f_datechk(ls_date) = -1 then
				f_message_chk(35,'[지시일자]')
				return 1
		  end if 
END Choose

RETURN 

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pm05_00190
integer y = 300
integer width = 4567
integer height = 2024
string dataobject = "d_pm05_00190"
boolean controlmenu = true
end type

type rr_1 from roundrectangle within w_pm05_00190
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 48
integer width = 2629
integer height = 216
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pm05_00190
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 23
integer y = 284
integer width = 4603
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

