object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 300
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 496
    Top = 224
    Width = 97
    Height = 41
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object PopupMenu1: TPopupMenu
    Left = 352
    Top = 144
    object N1: TMenuItem
      Caption = 'N1'
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = 'N2'
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = 'N3'
      OnClick = N3Click
    end
  end
  object Timer1: TTimer
    Interval = 460
    OnTimer = Timer1Timer
    Left = 248
    Top = 144
  end
end
