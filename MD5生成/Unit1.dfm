object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 274
  ClientWidth = 691
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
  object Memo1: TMemo
    Left = 40
    Top = 48
    Width = 457
    Height = 153
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Button2: TButton
    Left = 544
    Top = 80
    Width = 105
    Height = 41
    Caption = #29983#25104'MD5'
    TabOrder = 1
    OnClick = Button2Click
  end
end
