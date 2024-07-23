object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Login'
  ClientHeight = 104
  ClientWidth = 254
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object Label1: TLabel
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 234
    Height = 15
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 5
    Align = alTop
    Caption = 'C'#243'digo de acesso'
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 93
  end
  object Panel1: TPanel
    Left = 0
    Top = 63
    Width = 254
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 128
    ExplicitTop = 24
    ExplicitWidth = 185
    object pnlLogin: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 248
      Height = 35
      Cursor = crHandPoint
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Acessar'
      Color = 16744448
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      StyleElements = []
      OnClick = pnlLoginClick
      ExplicitLeft = 231
      ExplicitWidth = 150
    end
  end
  object edtCodigoAcesso: TEdit
    AlignWithMargins = True
    Left = 10
    Top = 30
    Width = 234
    Height = 23
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    PasswordChar = '*'
    TabOrder = 1
  end
end
