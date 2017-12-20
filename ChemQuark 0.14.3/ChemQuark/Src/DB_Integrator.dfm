object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 365
  Width = 578
  object DataSource1: TDataSource
    DataSet = RankingQuery
    OnDataChange = DataSource1DataChange
    Left = 32
    Top = 16
  end
  object ADOTable1: TADOTable
    Active = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Database.mdb;Persis' +
      't Security Info=False'
    CursorType = ctStatic
    TableName = 'Pontuacao'
    Left = 88
    Top = 40
  end
  object ADOQuery1: TADOQuery
    Active = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Database.mdb;Persis' +
      't Security Info=False'
    CursorType = ctStatic
    DataSource = DataSource1
    Parameters = <>
    SQL.Strings = (
      'Select * From Estequiometrico')
    Left = 184
    Top = 24
  end
  object RankingQuery: TADOQuery
    Active = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Database.mdb;Persis' +
      't Security Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * From Pontuacao')
    Left = 264
    Top = 24
  end
end
