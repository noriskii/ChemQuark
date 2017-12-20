object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 365
  Width = 578
  object DataSource1: TDataSource
    DataSet = ADOTable1
    Left = 32
    Top = 16
  end
  object ADOTable1: TADOTable
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Database.mdb;Persis' +
      't Security Info=False'
    CursorType = ctStatic
    TableName = 'Estequiometrico'
    Left = 88
    Top = 40
  end
  object ADOQuery1: TADOQuery
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
  object ADOQuery2: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Database.mdb;Persis' +
      't Security Info=False'
    CursorType = ctStatic
    DataSource = DataSource2
    Parameters = <>
    SQL.Strings = (
      'Select * From Professor')
    Left = 192
    Top = 120
  end
  object ADOTable2: TADOTable
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Database.mdb;Persis' +
      't Security Info=False'
    CursorType = ctStatic
    TableName = 'Professor'
    Left = 96
    Top = 136
  end
  object DataSource2: TDataSource
    DataSet = ADOTable2
    Left = 40
    Top = 112
  end
  object DataSource3: TDataSource
    DataSet = ADOTable3
    Left = 256
    Top = 216
  end
  object ADOTable3: TADOTable
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Database.mdb;Persis' +
      't Security Info=False'
    CursorType = ctStatic
    TableName = 'Administrador'
    Left = 312
    Top = 240
  end
  object ADOQuery3: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Database.mdb;Persis' +
      't Security Info=False'
    CursorType = ctStatic
    DataSource = DataSource3
    Parameters = <>
    SQL.Strings = (
      'Select * From Administrador')
    Left = 408
    Top = 224
  end
  object DataSource4: TDataSource
    DataSet = ADOQuery4
    Left = 328
    Top = 56
  end
  object ADOTable4: TADOTable
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Database.mdb;Persis' +
      't Security Info=False'
    CursorType = ctStatic
    TableName = 'Coeficiente'
    Left = 416
    Top = 120
  end
  object ADOQuery4: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=Database.mdb;Persis' +
      't Security Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT Solubilidade.Nome, Solubilidade.Substancia, Coeficiente.M' +
        'assa, Coeficiente.Temperatura, Coeficiente.Medida'
      
        'FROM Solubilidade INNER JOIN Coeficiente ON Solubilidade.[ID] = ' +
        'Coeficiente.[ID_Substancia];')
    Left = 480
    Top = 64
  end
end
