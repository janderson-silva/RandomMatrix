object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Gerador de N'#250'meros Aleat'#243'rios'
  ClientHeight = 441
  ClientWidth = 934
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 934
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Label1: TLabel
      Left = 100
      Top = 15
      Width = 71
      Height = 15
      Caption = 'Qtd. registros'
    end
    object Label2: TLabel
      Left = 190
      Top = 15
      Width = 71
      Height = 15
      Caption = 'Valor m'#237'nimo'
    end
    object Label3: TLabel
      Left = 280
      Top = 15
      Width = 73
      Height = 15
      Caption = 'Valor m'#225'ximo'
    end
    object Label4: TLabel
      Left = 10
      Top = 15
      Width = 67
      Height = 15
      Caption = 'Qtd. colunas'
    end
    object pnlGerar: TPanel
      AlignWithMargins = True
      Left = 781
      Top = 3
      Width = 150
      Height = 64
      Cursor = crHandPoint
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Gerar'
      Color = 8421440
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -27
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      StyleElements = []
      OnClick = pnlGerarClick
    end
    object spnQtdReg: TSpinEdit
      Left = 100
      Top = 35
      Width = 80
      Height = 24
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object spnValueMin: TSpinEdit
      Left = 190
      Top = 35
      Width = 80
      Height = 24
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 1
    end
    object spnValueMax: TSpinEdit
      Left = 280
      Top = 35
      Width = 80
      Height = 24
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 60
    end
    object spnQtdColuna: TSpinEdit
      Left = 10
      Top = 35
      Width = 80
      Height = 24
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 25
    end
  end
  object DBGrid1: TDBGrid
    AlignWithMargins = True
    Left = 3
    Top = 73
    Width = 928
    Height = 324
    Align = alClient
    DataSource = DataSource1
    DrawingStyle = gdsClassic
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object Panel2: TPanel
    Left = 0
    Top = 400
    Width = 934
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object pnlExportarXML: TPanel
      AlignWithMargins = True
      Left = 781
      Top = 3
      Width = 150
      Height = 35
      Cursor = crHandPoint
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Exportar .XML'
      Color = 8421440
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      StyleElements = []
      OnClick = pnlExportarXMLClick
    end
    object pnlExportarCSV: TPanel
      AlignWithMargins = True
      Left = 469
      Top = 3
      Width = 150
      Height = 35
      Cursor = crHandPoint
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Exportar .CSV'
      Color = 8421440
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      StyleElements = []
      OnClick = pnlExportarCSVClick
    end
    object pnlExportarJSON: TPanel
      AlignWithMargins = True
      Left = 625
      Top = 3
      Width = 150
      Height = 35
      Cursor = crHandPoint
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Exportar .JSON'
      Color = 8421440
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      StyleElements = []
      OnClick = pnlExportarJSONClick
    end
  end
  object FDMemTable1: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 328
    Top = 216
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 328
    Top = 272
  end
end
