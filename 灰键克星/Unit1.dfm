object KillGreyForm: TKillGreyForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #28784#38190#20811#26143
  ClientHeight = 112
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 27
    Width = 36
    Height = 13
    Caption = #26631#39064#65306
  end
  object Label2: TLabel
    Left = 32
    Top = 71
    Width = 36
    Height = 13
    Caption = #21477#26564#65306
  end
  object Edit1: TEdit
    Left = 80
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 80
    Top = 68
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit2'
  end
  object Button1: TButton
    Left = 232
    Top = 31
    Width = 73
    Height = 28
    Caption = #28608#27963
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 232
    Top = 65
    Width = 73
    Height = 27
    Caption = #20851#20110
    TabOrder = 3
    OnClick = Button2Click
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 152
    Top = 40
  end
  object PopupMenu1: TPopupMenu
    Left = 288
    Top = 72
    object show: TMenuItem
      Caption = #26174#31034
      OnClick = showClick
    end
    object N1: TMenuItem
      Caption = #36864#20986
      OnClick = N1Click
    end
  end
end
