$PBExportHeader$w_kgld01.srw
$PBExportComments$분개장 조회/출력
forward
global type w_kgld01 from w_standard_print
end type
type rb_1 from radiobutton within w_kgld01
end type
type rb_2 from radiobutton within w_kgld01
end type
type rr_1 from roundrectangle within w_kgld01
end type
type rr_2 from roundrectangle within w_kgld01
end type
end forward

global type w_kgld01 from w_standard_print
integer x = 0
integer y = 0
string title = "분개장 조회 출력"
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_kgld01 w_kgld01

forward prototypes
public function boolean wf_retrieve_gita (string symd, string sjun_gu)
public function integer wf_retrieve ()
end prototypes

public function boolean wf_retrieve_gita (string symd, string sjun_gu);String get_upmu
Int get_junno,i,jun_cnt, dis_row , icount

IF dw_print.Retrieve(sabu_f,sabu_t,symd,sjun_gu,sabu_nm) <= 0 THEN
	MessageBox("확 인"," 조회한 자료가 없습니다.!!!")
	Return False
ELSE
//	DECLARE save_junpyo CURSOR FOR  
//  	SELECT DISTINCT "KFZ10OT0"."UPMU_GU",   
//         			"KFZ10OT0"."JUN_NO"   
//
//    	FROM "KFZ10OT0" , "KFZ01OM0"  
//   	WHERE ( "KFZ01OM0"."ACC1_CD" = "KFZ10OT0"."ACC1_CD" ) and  
//            ( "KFZ01OM0"."ACC2_CD" = "KFZ10OT0"."ACC2_CD" ) and   
//		      (( "KFZ10OT0"."SAUPJ" >= :sabu_f ) AND 
//				( "KFZ10OT0"."SAUPJ" <= :sabu_t )) AND 
//         	( "KFZ10OT0"."ACC_DATE" = :symd ) AND  
//         	( "KFZ10OT0"."UPMU_GU" LIKE :sjun_gu )  AND
//				( "KFZ01OM0"."GBN2" = 'Y' ) ;
//	OPEN save_junpyo;
//	i = 1
//	DO WHILE true
//		FETCH save_junpyo INTO :get_upmu, 
//                          	  :get_junno;
//   	IF SQLCA.SQLCODE <> 0 THEN
//      	exit
//   	END IF
//		jun_cnt =jun_cnt+1            
//   	i++
//	LOOP
//	CLOSE save_junpyo;
//	 dw_list.SetItem(1,"jun_cnt",jun_cnt)
//     
//	 dis_row =dw_list.RowCount()
//	   FOR icount = 1 TO dis_row  STEP 1
//          IF sjun_gu ="%" THEN
//		       dw_list.SetItem(icount,"upmu_gu","전체")
//		    else
//				 dw_list.setitem(icount,"upmu_gu",sjun_gu)
//		    END IF
//   	next	
	
   
END IF

dw_print.sharedata(dw_list)

Return True
	


end function

public function integer wf_retrieve ();String  sSaupj,sAccYmdF,ls_jun_gu,sCashAcc,sBefYmd,sAccYmdT
Integer iRow

dw_ip.AcceptText()

sSaupj =Trim(dw_ip.GetItemString(1,"saupj"))
sAccYmdF  = Trim(dw_ip.GetItemString(1,"k_symd"))
sAccYmdT = Trim(dw_ip.GetItemString(1,"k_eymd"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

ls_jun_gu = dw_ip.GetItemString(1,"upmu_gu")
IF ls_jun_gu = "" OR IsNull(ls_jun_gu) THEN ls_jun_gu = "%"

if sAccYmdF = "" or isnull(sAccYmdF) then
	f_messagechk( 23,"")
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	return 1
end if 
if sAccYmdT = "" or isnull(sAccYmdT) then
	f_messagechk( 23,"")
	dw_ip.SetColumn("k_eymd")
	dw_ip.SetFocus()
	return 1
end if 
IF rb_1.Checked =True THEN
	dw_print.dataobject = 'dw_kgld012_p'
	dw_print.settransobject(sqlca)
	
	iRow = dw_print.Retrieve(sabu_f,sabu_t,sAccYmdF,sAccYmdT,ls_jun_gu,sabu_nm)
ElseIF rb_2.Checked =True THEN
	dw_print.dataobject = 'dw_kgld013_p'
	dw_print.settransobject(sqlca)
	iRow = dw_print.Retrieve(sabu_f,sabu_t,sAccYmdF,sAccYmdT,ls_jun_gu,sabu_nm)
END IF

dw_print.sharedata(dw_list)

if iRow <=0 then
	F_MessageChk(14,'')
	Return -1
end if

dw_ip.SetFocus()

Return 1
end function

on w_kgld01.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_kgld01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_ip.SetItem(1,"upmu_gu", 'A')
dw_ip.SetItem(1,"k_symd",  f_today())
dw_ip.SetItem(1,"k_eymd",  f_today())
dw_ip.SetItem(1,"saupj",   gs_saupj)
dw_ip.SetFocus()

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)



end event

type p_preview from w_standard_print`p_preview within w_kgld01
end type

type p_exit from w_standard_print`p_exit within w_kgld01
end type

type p_print from w_standard_print`p_print within w_kgld01
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld01
end type







type st_10 from w_standard_print`st_10 within w_kgld01
end type



type dw_print from w_standard_print`dw_print within w_kgld01
integer x = 4201
integer y = 180
string dataobject = "dw_kgld012_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld01
integer y = 32
integer width = 2958
integer height = 144
string dataobject = "dw_kgld011"
end type

type dw_list from w_standard_print`dw_list within w_kgld01
integer x = 69
integer y = 200
integer width = 4535
integer height = 2028
string title = "계정과목별 인쇄"
string dataobject = "dw_kgld012"
boolean border = false
end type

type rb_1 from radiobutton within w_kgld01
integer x = 3063
integer y = 60
integer width = 389
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "계정과목별"
boolean checked = true
end type

event clicked;
dw_list.SetRedraw(False)
IF rb_1.Checked =True THEN
	dw_list.dataObject='dw_kgld012'
END IF

dw_list.title ="계정과목별"
dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)

end event

type rb_2 from radiobutton within w_kgld01
integer x = 3474
integer y = 60
integer width = 389
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "전표번호별"
end type

event clicked;dw_list.SetRedraw(False)
IF rb_2.Checked =True THEN
	dw_list.dataObject='dw_kgld013'
END IF

dw_list.title ="전표번호별"
dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)

end event

type rr_1 from roundrectangle within w_kgld01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3026
integer y = 32
integer width = 873
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kgld01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 188
integer width = 4576
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

