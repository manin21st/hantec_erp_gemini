$PBExportHeader$w_sal_05930.srw
$PBExportComments$분기시상금 지급현황
forward
global type w_sal_05930 from w_standard_print
end type
end forward

global type w_sal_05930 from w_standard_print
string title = "분기시상금 지급현황"
long backcolor = 80859087
end type
global w_sal_05930 w_sal_05930

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String	syear, sSteam, sSarea, tx_name
Long     nRow

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return 0

syear  = trim(dw_ip.getitemstring(1, 'syear'))
sSteam = trim(dw_ip.getitemstring(1, 'deptcode'))
sSarea = trim(dw_ip.getitemstring(1, 'areacode'))

IF	IsNull(syear) or syear = '' then
	f_message_chk(1400,'[기준년도]')
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	Return -1
END IF

If IsNull(sSteam) Then sSteam = ''
If IsNull(sSarea) Then sSarea = ''
////////////////////////////////////////////////////////////////
dw_list.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

nRow = dw_list.retrieve(syear, sSteam+'%', sSarea+'%',ls_silgu)
if nRow < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('syear')
	dw_ip.setfocus()
	return -1
end if

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("txt_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("txt_sarea.text = '"+tx_name+"'")


dw_list.SetRedraw(True)
Return 1


end function

on w_sal_05930.create
call super::create
end on

on w_sal_05930.destroy
call super::destroy
end on

event open;call super::open;
dw_ip.SetItem(1,'syear',Left(f_today(),4))

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
   dw_ip.Modify("areacode.protect=1")
	dw_ip.Modify("deptcode.protect=1")
	dw_ip.Modify("areacode.background.color = 80859087")
	dw_ip.Modify("deptcode.background.color = 80859087")
End If
dw_ip.SetItem(1, 'areacode', sarea)
dw_ip.SetItem(1, 'deptcode', steam)
end event

type p_preview from w_standard_print`p_preview within w_sal_05930
end type

type p_exit from w_standard_print`p_exit within w_sal_05930
end type

type p_print from w_standard_print`p_print within w_sal_05930
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05930
end type







type st_10 from w_standard_print`st_10 within w_sal_05930
end type



type dw_print from w_standard_print`dw_print within w_sal_05930
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05930
integer x = 37
integer y = 100
integer width = 745
integer height = 588
string dataobject = "d_sal_05930_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  sNull, sIoCustArea, sDept

SetNull(snull)

Choose Case GetColumnName() 
	/* 영업팀 */
	Case "deptcode"
		SetItem(1,'areacode',sNull)
	/* 관할구역 */
	Case "areacode"
		sIoCustArea = this.GetText()
		IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
			
		SetItem(1,'deptcode',sDept)
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_05930
integer x = 805
integer width = 2807
integer height = 2056
string dataobject = "d_sal_05930"
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

