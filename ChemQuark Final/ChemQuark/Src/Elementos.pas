unit Elementos;

interface

type
//==============================================================================
// ** TElemento
//------------------------------------------------------------------------------
// Esta classe é responsável por toda a informação referente aos elementos
// periódicos. É usada internamente pela classe DB_Integrator.
//==============================================================================
  TElemento = Class

    private

      ID, Periodo : Byte;

      Calor_Especifico,
      Massa_Atomica : Real;

      Nome,
      Simbolo,
      Grupo,
      Bloco,
      Eletrons,
      Serie_Quimica,
      Configuracao_Eletronica,
      Estrutura_Cristalina,
      Pressao_Vapor,
      Estado_Materia,
      Classe_Magnetica,
      Raio_VanDerWalls,
      Ponto_Fusao,
      Raio_Atomico,
      Raio_Covalente,
      Ponto_Ebulicao,
      Velocidade_Som,
      Condutividade_Termica,
      Potencial_Ionizacao,
      Eletronegatividade,
      Picture : String;

    public

      var
        Descricao      : String;

      function Get_Elemento( Index : Byte ): String;

      published

        constructor Create ( Numero_Atomico : Byte;
            Nome, Simbolo : String;
            Massa_Atomica : Real;
            Grupo : String;
            Periodo : Byte;
            Bloco, Eletrons, Serie_Quimica : String;
            Raio_Atomico, Raio_Covalente : String;
            Raio_VanDerWalls : String;
            Configuracao_Eletronica, Estrutura_Cristalina : String;
            Estado_Materia : String;
            Ponto_Fusao, Ponto_Ebulicao : String;
            Pressao_Vapor : String;
            Velocidade_Som : String;
            Calor_Especifico : Real;
            Condutividade_Termica, Potencial_Ionizacao : String;
            Classe_Magnetica : String;
            Eletronegatividade : String;
            Descricao : String;
            Picture   : String = 'Graphics/Properties/Pictures/NoOne' );

  End;

implementation

{ TElemento }

  uses SysUtils;

  //----------------------------------------------------------------------
  // * Inicializa a instância de acordo com os parâmetros dados
  //----------------------------------------------------------------------
  constructor TElemento.Create( Numero_Atomico: Byte; Nome: string;
         Simbolo: string; Massa_Atomica: Real; Grupo: string; Periodo: Byte;
         Bloco: string; Eletrons: string; Serie_Quimica: string;
         Raio_Atomico: String; Raio_Covalente: String; Raio_VanDerWalls: String;
         Configuracao_Eletronica: string; Estrutura_Cristalina: string;
         Estado_Materia: string; Ponto_Fusao: String; Ponto_Ebulicao: String;
         Pressao_Vapor: String; Velocidade_Som: String; Calor_Especifico: Real;
         Condutividade_Termica: String; Potencial_Ionizacao: String;
         Classe_Magnetica: string; Eletronegatividade: String;
         Descricao : String; Picture : String = 'Graphics/Properties/Pictures/NoOne' );
  begin

    self.ID                       := Numero_Atomico;
    self.Nome                     := Nome;
    self.Simbolo                  := Simbolo;
    self.Massa_Atomica            := Massa_Atomica;
    self.Grupo                    := Grupo;
    self.Periodo                  := Periodo;
    self.Bloco                    := Bloco;
    self.Eletrons                 := Eletrons;
    self.Serie_Quimica            := Serie_Quimica;
    self.Raio_Atomico             := Raio_Atomico;
    self.Raio_Covalente           := Raio_Covalente;
    self.Raio_VanDerWalls         := Raio_VanDerWalls;
    self.Configuracao_Eletronica  := Configuracao_Eletronica;
    self.Estrutura_Cristalina     := Estrutura_Cristalina;
    self.Estado_Materia           := Estado_Materia;
    self.Ponto_Fusao              := Ponto_Fusao;
    self.Ponto_Ebulicao           := Ponto_Ebulicao;
    self.Pressao_Vapor            := Pressao_Vapor;
    self.Velocidade_Som           := Velocidade_Som;
    self.Calor_Especifico         := Calor_Especifico;
    self.Condutividade_Termica    := Condutividade_Termica;
    self.Potencial_Ionizacao      := Potencial_Ionizacao;
    self.Classe_Magnetica         := Classe_Magnetica;
    self.Eletronegatividade       := Eletronegatividade;
    self.Descricao                := Descricao;
    Self.Picture                  := Picture;

  end;
  //----------------------------------------------------------------------
  // * Retorna informações de acordo com o parâmetro cedido
  //     Index : Informação requisitada
  //----------------------------------------------------------------------
  function TElemento.Get_Elemento(Index: Byte) : String;
  begin
    case Index of
      0:  Result := IntToStr(ID);
      1:  Result := Nome;
      2:  Result := Simbolo;
      3:  Result := FloatToStr(Massa_Atomica);
      4:  Result := Grupo;
      5:  Result := IntToStr(Periodo);
      6:  Result := Bloco;
      7:  Result := Eletrons;
      8:  Result := Serie_Quimica;
      9:  Result := Raio_Atomico;
      10: Result := Raio_Covalente;
      11: Result := Raio_VanDerWalls;
      12: Result := Configuracao_Eletronica;
      13: Result := Estrutura_Cristalina;
      14: Result := Estado_Materia;
      15: Result := Ponto_Fusao;
      16: Result := Ponto_Ebulicao;
      17: Result := Pressao_Vapor;
      18: Result := Velocidade_Som;
      19: Result := FloatToStr(Calor_Especifico);
      20: Result := Condutividade_Termica;
      21: Result := Classe_Magnetica;
      22: Result := Eletronegatividade;
      23: Result := Descricao;
      24: Result := Potencial_Ionizacao;
      25: Result := Picture + '.png';
    end;
  end;

end.

