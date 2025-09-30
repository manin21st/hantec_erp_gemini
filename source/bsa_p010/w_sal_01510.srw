$PBExportHeader$w_sal_01510.srw
$PBExportComments$장기 판매계획 현황
forward
global type w_sal_01510 from w_standard_print
end type
type dw_graph from datawindow within w_sal_01510
end type
type ole_1 from uo_chartdata within w_sal_01510
end type
type rr_1 from roundrectangle within w_sal_01510
end type
end forward

global type w_sal_01510 from w_standard_print
integer height = 2512
string title = "장기판매계획현황"
dw_graph dw_graph
ole_1 ole_1
rr_1 rr_1
end type
global w_sal_01510 w_sal_01510

type variables




end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_chart ()
end prototypes

public function integer wf_retrieve ();String sYear, sSteam, sGubun
Long iYear
decimal damt

dw_ip.AcceptText()
dw_graph.accepttext()

sYear = Trim(dw_ip.GetItemString(1,'syy'))
if	(sYear='') or isNull(sYear) or Len(sYear) <> 4 then
	f_Message_Chk(35, '[기준년도]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	Return -1
end if

iYear = Long(sYear)
sGubun = Trim(dw_ip.GetItemString(1,'sgubun'))
ssTeam  = Trim(dw_ip.GetItemString(1,'ssteam'))
dAmt = dw_graph.getitemdecimal(1, "amtunit")

If sGubun = 'sLong' then
	dw_print.dataobject = "d_sal_01510_04_p"
	dw_list.dataobject  = "d_sal_01510_04"
	
	dw_print.settransobject(sqlca)
	dw_list.settransobject(sqlca)
	
	if dw_print.Retrieve(gs_sabu, sYear, iYear, dAmt) < 1 then
		messagebox("확인", "출력자료가 없습니다!")
		dw_ip.setcolumn('syy')
		dw_ip.setfocus()
		return -1
	end if
	
	wf_chart()	
	
	dw_list.Retrieve(gs_sabu, sYear, iYear, dAmt)
	
ElseIf sGubun = 'sTeam' then
	
	dw_print.dataobject = "d_sal_01510_03_p"
	dw_list.dataobject  = "d_sal_01510_03"
	
	dw_print.settransobject(sqlca)
	dw_list.settransobject(sqlca)
	
	if dw_print.Retrieve(gs_sabu, sYear, iYear, dAmt) < 1 then
		messagebox("확인", "출력자료가 없습니다!")
		dw_ip.setcolumn('syy')
		dw_ip.setfocus()
		return -1
	end if
	
	wf_chart()	
	
	dw_list.Retrieve(gs_sabu, sYear, iYear, dAmt)	
	
	
ElseIf sGubun = 'sArea' then	
	
	dw_print.dataobject = "d_sal_01510_02_p"
	dw_list.dataobject  = "d_sal_01510_02"
	
	dw_print.settransobject(sqlca)
	dw_list.settransobject(sqlca)
	
	if dw_print.Retrieve(gs_sabu, sYear, iYear, dAmt, ssTeam) < 1 then
		messagebox("확인", "출력자료가 없습니다!")
		dw_ip.setcolumn('syy')
		dw_ip.setfocus()
		return -1
	end if
	
	wf_chart()	
	
	dw_list.Retrieve(gs_sabu, sYear, iYear, dAmt, sSteam)
	
	
End if

return 1
end function

public function integer wf_chart ();int				i, j, li_colno = 0, li_rowcnt = 0, ii
st_chartdata_business	lst_chartdata
string			ls_colname, ls_colchk
boolean			lb_sumtag = false

if dw_graph.accepttext() = -1 then return -1
if dw_graph.object.sumtag[1] = 'Y' then lb_sumtag = true

if dw_print.rowcount() <= 0 then return -1

// column의 갯수
li_rowcnt = 10

lst_chartdata.toptitle  = dw_ip.object.syy[1] + '년도 장기판매계획'
if lb_sumtag then
	lst_chartdata.rowcnt    = li_rowcnt +1
else
	lst_chartdata.rowcnt    = li_rowcnt
end if

// row의 갯수
if dw_ip.getitemstring(1, "sgubun") = 'sLong' then
	lst_chartdata.colcnt    = 3
ElseIf dw_ip.getitemstring(1, "sgubun") = 'sTeam' then
	lst_chartdata.colcnt    = dw_print.rowcount()
ElseIf dw_ip.getitemstring(1, "sgubun") = 'sArea' then
	lst_chartdata.colcnt    = dw_print.rowcount()
End if

// 시리즈별 누계
if dw_graph.object.acutag[1] = 'Y' then
	lst_chartdata.cumulative = true
else
	lst_chartdata.cumulative = false
end if

// 전체 누계
if dw_graph.object.tottag[1] = 'Y' then
	lst_chartdata.totsumchk = true
else
	lst_chartdata.totsumchk = false
end if

// 누계column표시(특정column을 누계로 할 경우에는 Column-No를 아니면 0
if dw_ip.getitemstring(1, "sgubun") = 'sLong' then
	lst_chartdata.totstrno = 3
ElseIf dw_ip.getitemstring(1, "sgubun") = 'sTeam' then
	lst_chartdata.totstrno = 0
ElseIf dw_ip.getitemstring(1, "sgubun") = 'sArea' then
	lst_chartdata.totstrno = 0
End if

// Label표시
if dw_graph.object.pointlables[1] = 'Y' then
	lst_chartdata.labelchk = true
else
	lst_chartdata.labelchk = false
end if

for i = 1 to li_rowcnt
	 ls_colname = "year" + string(i)
	 lst_chartdata.rowname[i] = string(dw_print.getitemnumber(1, ls_colname))
next


if lb_sumtag then lst_chartdata.rowname[li_rowcnt +1] = + '合 計'

for i = 1 to lst_chartdata.colcnt

	if dw_ip.getitemstring(1, "sgubun") = 'sLong' then
		choose case i
			case 1
				  ls_colname = '국 내  매 출'
			case 2			  
				  ls_colname = '해 외  매 출'
			case 3			  
				  ls_colname = '총   매   출'
		end choose
	ElseIf dw_ip.getitemstring(1, "sgubun") = 'sTeam' then
		ls_colname = dw_print.getitemstring(i, "steamnm")
	ElseIf dw_ip.getitemstring(1, "sgubun") = 'sArea' then
		ls_colname = dw_print.getitemstring(i, "steamnm")
	End if
	
	li_colno++

	lst_chartdata.colname[li_colno] = ls_colname
	if dw_graph.object.bartag[1] = 'Y' then
		lst_chartdata.gallery[li_colno] = 2
	else
		lst_chartdata.gallery[li_colno] = 1
	end if
	
	lst_chartdata.pointlabels[li_colno] = False

	for j = 1 to li_rowcnt
		 
		if dw_ip.getitemstring(1, "sgubun") = 'sLong' then
			 if i = 1 then
				ls_colchk = 'in_amt_' + string(j)
			 ElseIf i = 2 then
				ls_colchk = 'out_amt_' + string(j)
			 Else
				ls_colchk = 'tot_amt_' + string(j)
			 End if
		ElseIf dw_ip.getitemstring(1, "sgubun") = 'sTeam' then
				ls_colchk = 'in_amt_' + string(j)
		ElseIf dw_ip.getitemstring(1, "sgubun") = 'sArea' then
				ls_colchk = 'in_amt_' + string(j)
		End if
		 
		 
		if dw_ip.getitemstring(1, "sgubun") = 'sLong' then
			 lst_chartdata.value[j,li_colno] = dw_print.getitemdecimal(1, ls_colchk)
			 If dw_print.getitemdecimal(1, ls_colchk) <> 0 then
				 lst_chartdata.pointlabels[li_colno] = true		 
			 End if
			 if lb_sumtag then 
				 If j = 1 then
					 lst_chartdata.value[li_rowcnt +1, li_colno] =  dw_print.getitemdecimal(1, ls_colchk)
				 Else
					 lst_chartdata.value[li_rowcnt +1, li_colno] =  dw_print.getitemdecimal(1, ls_colchk) + &
																					lst_chartdata.value[li_rowcnt +1, li_colno]				 
				 End if
			 End if
		ElseIf dw_ip.getitemstring(1, "sgubun") = 'sTeam' or  dw_ip.getitemstring(1, "sgubun") = 'sArea'then
			 lst_chartdata.value[j,li_colno] = dw_print.getitemdecimal(li_colno, ls_colchk)
			 If dw_print.getitemdecimal(li_colno, ls_colchk) <> 0 then
				 lst_chartdata.pointlabels[li_colno] = true		 
			 End if
			 if lb_sumtag then 
				 If j = 1 then
					 lst_chartdata.value[li_rowcnt +1, li_colno] =  dw_print.getitemdecimal(li_colno, ls_colchk)
				 Else
					 lst_chartdata.value[li_rowcnt +1, li_colno] =  dw_print.getitemdecimal(li_colno, ls_colchk) + &
																					lst_chartdata.value[li_rowcnt +1, li_colno]				 
				 End if
			 End if
		End if		 
		 
	next
next

lst_chartdata.dwname = dw_print
lst_chartdata.wname  = "w_sal_01510"
f_chart_setup(lst_chartdata) // Datawindow Setup
ole_1.setdata(lst_chartdata) // window Setup

return 1

end function

on w_sal_01510.create
int iCurrent
call super::create
this.dw_graph=create dw_graph
this.ole_1=create ole_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_graph
this.Control[iCurrent+2]=this.ole_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_sal_01510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_graph)
destroy(this.ole_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_graph.insertrow(0)
dw_ip.setfocus()
end event

type p_preview from w_standard_print`p_preview within w_sal_01510
end type

type p_exit from w_standard_print`p_exit within w_sal_01510
end type

type p_print from w_standard_print`p_print within w_sal_01510
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_01510
end type







type st_10 from w_standard_print`st_10 within w_sal_01510
end type



type dw_print from w_standard_print`dw_print within w_sal_01510
boolean visible = true
integer x = 261
integer y = 1676
integer width = 3982
integer height = 556
string dataobject = "d_sal_01510_04_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_01510
integer x = 18
integer y = 20
integer width = 2432
integer height = 164
string dataobject = "d_sal_01510_01"
end type

event dw_ip::itemchanged;call super::itemchanged;String sCol_Name, sNull

sCol_Name = This.GetColumnName()
SetNull(sNull)

Choose Case sCol_Name
   // 수립년도 유효성 Check
	Case "syy"  
		if (Not(isNumber(Trim(this.getText())))) or (Len(Trim(this.getText())) <> 4) then
			f_Message_Chk(35, '[수립년도]')
			this.SetItem(1, "syy", sNull)
			return 1
		end if
		
	Case "sgubun"
		dw_list.SetRedraw(False)
		this.setItem(1,"ssteam", sNull)

		dw_list.SetRedraw(True)
end Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_01510
integer x = 96
integer y = 1524
integer width = 4466
integer height = 788
string dataobject = "d_sal_01510_04"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_graph from datawindow within w_sal_01510
integer x = 2542
integer y = 24
integer width = 1239
integer height = 204
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_sal_graph"
boolean border = false
boolean livescroll = true
end type

event itemchanged;post wf_chart()
end event

type ole_1 from uo_chartdata within w_sal_01510
integer x = 82
integer y = 252
integer width = 1317
integer height = 768
integer taborder = 20
boolean bringtotop = true
string binarykey = "w_sal_01510.win"
end type

type rr_1 from roundrectangle within w_sal_01510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 232
integer width = 4553
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 55
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
03w_sal_01510.bin 
2500001600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffe00000005fffffffe00000006000000070000000800000009fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000100000000000000000000000000000000000000000000000000000000e36e1bd001c46adc0000000300000a400000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe0000000000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff0000000321f498a211d2bfa910009ca8dabd624b00000000e35b090001c46adce36e1bd001c46adc000000000000000000000000004f00010065006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000102000affffffff00000004ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400000000fffffffe00000002000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f000000200000002100000022000000230000002400000025000000260000002700000028fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
20ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0200000100000008000000000000000000000000007300670020002c006e0069006500740065006700200072007000780073006f0020002c006e0069006500740000030000006549000020a948435f5f465452415f5f3458040005002ebf0f0000020000000246a8ffff00000032ff7f001e002c0000001e00000004000000000050000000000001000020840000031000020004000000000000000000000000000b001000010003000000000001004b0000000000030000000000010000008000000000007f000000000000000000000000c024000000000000c0240000000000003ff000000000000000000000000000004059000000000002000000003828000280010000000000000000000000003ff00000000000000000000180000010000000018000001000000000000000000000000000000000000000000000000000000000c024000000000000c0240000000000003ff0000000000000000000000000000040590000000000000000000038280002000100000000000200000000000000000000000000003ff000010000001000000001800000100000000080000000000000000000000000000000000000000000000000000000000000003ff0000000000000bff00000000000003ff000000000000000000000000000004059000000000000000000003828000200010000000040440000000000003ff00000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020012ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000001000009fe000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000180000010000000018000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003ff00000ffffffff7fefffffffffffffffefffff000000000000000038680002000100000000000200000000000000000000000000003ff000010000001000000001800000100000000080000000000000000000000000000000000000000000000100000000010000010100000f010000108000000000c40031030000ffffff00e0e0e000c0c0c000a0a0a0008080800060606000000000008040800080008000c000c000ff00ff00ff40ff00ff80ff00ffc0ff00c0c0ff008080ff004040ff000000ff000000c0000000800040408000408080000080800000c0c00000ffff0040ffff0080ffff00c0ffff00c0ffc00080ff800040ff400000ff000000c0000000800000408040008080400080800000c0c00000ffff0000ffff4000ffff8000ffffc000ffc0c000ff808000ff404000ff000000c0000000800000000000800000ff0000ff0000000000ff00ff00ff0000ffff00ffff00008000ff0080ff000000ff8000ff00800080ffff00ffff8000408080008040800080804000ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff00ffffff000000000000000000000000200000080000000060000008000000000000000800000000000000080000000000000008000000000000000800000000000000080000000000000008000000000000000800000000000a000c000000000000000800000000000000080000000000000008000000050000000200000000000000000000000500000002000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000010008ff00000000000000000000000000000000000000000000000002030100000076030006000000000000b1000001f555c42aa111d3440450005dff6451a7010000ff0000010055c42ab111d344f550005da16451a7040000ffff00010002c42ab100d344f555005da11151a7045000ffff64010003002ab1000044f555c45da111d3a7045000ffff645100040000b1000001f555c42aa111d3440450005dff6451a7050000ff0000010055c42ab111d344f550005da16451a7040000ffff01000601c435000098f39f373b9c11d14d24a000ffff202900010000
2E0000000673677300001c00680045006b73450150000002200000016e0001ffff00680012760001260000012100410010006e006e0074006f0074006100200065006f0054006c006f00610062ffff0072012600690121760100100000006e0041006f006e006100740065007400540020006f006f0062006c00720061006affff760201260000012100410010006e006e0074006f0074006100200065006f0054006c006f00610062ffff00720000ffff0007731031000001f39f37c49c11d19824a0003bff20294d6b0000ffe0000030030000011000000200038673000001000003d30000013b0000038500000001000003d30000013b0053000d0072006500650069002000730065004c006500670064006e00ff000600ffffffffffffffffffffffff01ffffff28010000280000000200000028000000280000004d00000018000000ff000000ffffffff01ffffff02400002ff00000013ffffff01000873c433000098f39f373b9c11d14d24a000ffff202972cb0000001006000100000073130000000000090000001e0000028600000038000000010000001e0000028600000039004d0004006e006500060075ffffffffffffffff000000e6000000308000000f000000de0000003dfffffff000000028000000280000001500000019ffffffffffffffff40000046000000020000010400000001000000030000000100000003000c8084000400040006000009730f00000001009f37c43111d198f3a0003b9c20294d240000ffff0000306b000000a00000020302d4730f001e000002d4000001bf000002d30000001e000002d4000001bf0000000600000065004c006500670064006effff0006ffffffffffffffffffffffff0001ffff00280100002800000002000000280000002800000000000000180000ffff0000ffffffff0301ffff00024000731400000001000a37c43100d198f39f003b9c11294d24a000ffff200070eb000000300000010000097314001e000000d400000035000002010000001e000000d4000000360000020a0000006100500065006c00740074004200650072006100ff000600ffffffffffffffffffffffff0fffffff2880000028000000ff00000016ffffff160000001600000016000000ff000000ffffffff40ffffff024000011500000001000b73c431000098f39f373b9c11d14d24a000ffff202970eb0000003000000100000073150000000000090000001e000002d400000035000000010000001e000002d4000000360050000a0074006100650074006e00720061004200060072ffffffffffffffffffffffffffffffff8000000f0000002800000028ffffffff00000016000000160000001600000016ffffffffffffffff4000014000000002000c731233000001f39f37c49c11d19824a0003bff20294dcb0000ff70060070000000001200000100000973000001000002d40000001d0000000100000001000002d40000001e00540007006f006f0062006c0072006100ff000600ffffffffd5ffffff330000010f000000cd800000a2000001f000000128ffffff28000000190000001c000000ff000000ffffffff46ffffff02400000020000000100000103000000010000000300000044000000090000000000040000000600d560ffffc5edad6c0020bcc4ac04b144d31000200020b9e4d68dacc40000c11c006400730073005f006c00610030005f00350031003000330030005f002e0032007200730020006400780028002000290033002800380032003000300020002900300032003400300030002d002d00370036003100310020003a0031003400320035003a00200036003d0020003d003d0020003ed560ad00c5edad6c0020bcc4ac04b144d31000200020b9e4d68dacc40000c11c006400730073005f006c00610030005f00350031003000330030005f005f0031002e0070007200730020006400780028002000290034002800310034003900340020002900300032003300300031002d002d00300039003000320020003a0030003200350035003a00200033003d0020003d003d0020003ec5c5c601bcc4d300b14400200020ac04b9e4d310acc40020c11cd68d00730000005f006400610073005f006c0031003000330035005f0030003100300073002e006400720028002000290078002800200033003300390037002900360032002000300030002d0034003700300031002d00200036003100310032003a003a00340031003300200020003d003d003e003dc6010020d300c5c500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
13w_sal_01510.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
