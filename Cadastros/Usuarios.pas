unit Usuarios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Buttons;

type
  TFrmUsuarios = class(TForm)
    btnNovo: TSpeedButton;
    btnSalvar: TSpeedButton;
    btnEditar: TSpeedButton;
    btnExcluir: TSpeedButton;
    DBGrid1: TDBGrid;
    EdtNome: TEdit;
    lb_nome: TLabel;
    EdtBuscarNome: TEdit;
    lb_buscar: TLabel;
    btnBuscarFuncionario: TSpeedButton;
    EdtUsuario: TEdit;
    Label1: TLabel;
    EdtSenha: TEdit;
    Label2: TLabel;
    procedure btnBuscarFuncionarioClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure EdtBuscarNomeChange(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure btnExcluirClick(Sender: TObject);

  private
    { Private declarations }
      procedure limpar;
      procedure habilitarCampos;
      procedure desabilitarCampos;
      procedure verificaCadastro;

      procedure associarCampos;
      procedure listar;
      procedure buscarNome;

  public
    { Public declarations }
  end;

var
  FrmUsuarios: TFrmUsuarios;
  usuarioAntigo: String;

implementation

{$R *.dfm}

uses Modulo, Menu, Funcionarios;

procedure TFrmUsuarios.btnBuscarFuncionarioClick(Sender: TObject);
begin
  chamada := 'Func';
  FrmFuncionarios := TFrmFuncionarios.Create(self);
  FrmFuncionarios.Show;
end;

procedure TFrmUsuarios.btnEditarClick(Sender: TObject);
 var
  usuario: string;
  begin
    if Trim(EdtNome.Text) = '' then
      begin
        MessageDlg('Preencha o Nome!', mtInformation, mbOKCancel, 0);
        EdtNome.SetFocus;
        exit;
      end;

       if Trim(EdtUsuario.Text) = '' then
      begin
        MessageDlg('Preencha o Usuario!', mtInformation, mbOKCancel, 0);
        EdtUsuario.SetFocus;
        exit;
      end;

      if Trim(EdtSenha.Text) = '' then
      begin
        MessageDlg('Preencha a Senha!', mtInformation, mbOKCancel, 0);
        EdtSenha.SetFocus;
        exit;
      end;

      if usuarioAntigo <> EdtUsuario.Text then
      begin
        verificaCadastro;
        if not dm.query_usuarios.IsEmpty then
           begin
             usuario := dm.query_usuarios['usuario'];
             MessageDlg('O usuario ' + usuario + ' j� esta cadastrado!', mtInformation, mbOKCancel, 0);
             EdtUsuario.Text := '';
             EdtUsuario.SetFocus;
             Exit;
           end;
      end;

      if not dm.query_usuarios.IsEmpty then
     begin
       usuario := dm.query_usuarios['usuario'];
       MessageDlg('O Usu�rio ' + usuario + ' j� esta cadastrado!', mtInformation, mbOKCancel, 0);
       EdtUsuario.Text := '';
       EdtUsuario.SetFocus;
       Exit;
     end;

    dm.query_usuarios.Close;
    dm.query_usuarios.SQL.Clear;
    dm.query_usuarios.SQL.Add('UPDATE usuarios set nome = :nome, usuario = :usuario, senha = :senha WHERE id = :id');
    dm.query_usuarios.ParamByName('nome').Value := EdtNome.Text;
    dm.query_usuarios.ParamByName('usuario').Value := EdtUsuario.Text;
    dm.query_usuarios.ParamByName('senha').Value := EdtSenha.Text;
    dm.query_usuarios.ParamByName('id').Value := id;
    dm.query_usuarios.ExecSQL;

    listar;
    MessageDlg('Editado com sucesso!!', mtInformation, mbOKCancel, 0);
    btnEditar.Enabled := False;
    btnExcluir.Enabled := False;
    limpar;
    desabilitarCampos;



end;

procedure TFrmUsuarios.btnExcluirClick(Sender: TObject);
begin
    if MessageDlg('Deseja Excluir o registro?', mtConfirmation,[mbYes,mbNo],0) = mrYes then
  begin
     dm.query_usuarios.Close;
     dm.query_usuarios.SQL.Clear;
     dm.query_usuarios.SQL.Add('DELETE FROM usuarios WHERE id = :id');
     dm.query_usuarios.ParamByName('id').Value := id;
     dm.query_usuarios.ExecSQL;
     MessageDlg('Deletado com Sucesso!!', mtInformation, mbOKCancel, 0);

     listar;
     limpar;
     desabilitarCampos;
     btnEditar.Enabled := False;
     btnExcluir.Enabled := False;

  end;
end;

procedure TFrmUsuarios.btnNovoClick(Sender: TObject);
begin
   habilitarCampos;
   dm.tb_usuarios.Insert;
   btnSalvar.Enabled := True;
end;

procedure TFrmUsuarios.btnSalvarClick(Sender: TObject);
 var
  usuario: string;
  begin
    if Trim(EdtNome.Text) = '' then
      begin
        MessageDlg('Preencha o Nome!', mtInformation, mbOKCancel, 0);
        EdtNome.SetFocus;
        exit;
      end;

       if Trim(EdtUsuario.Text) = '' then
      begin
        MessageDlg('Preencha o Usuario!', mtInformation, mbOKCancel, 0);
        EdtUsuario.SetFocus;
        exit;
      end;

      if Trim(EdtSenha.Text) = '' then
      begin
        MessageDlg('Preencha a Senha!', mtInformation, mbOKCancel, 0);
        EdtSenha.SetFocus;
        exit;
      end;

    verificaCadastro;

      if not dm.query_usuarios.IsEmpty then
     begin
       usuario := dm.query_usuarios['usuario'];
       MessageDlg('O Usu�rio ' + usuario + ' j� esta cadastrado!', mtInformation, mbOKCancel, 0);
       EdtUsuario.Text := '';
       EdtUsuario.SetFocus;
       Exit;
     end;

    associarCampos;
    dm.tb_usuarios.Post;
    MessageDlg('Salvo com Sucesso!', mtInformation, mbOKCancel,0);
    limpar;
    desabilitarCampos;
    btnSalvar.Enabled := false;
    listar;
end;

procedure TFrmUsuarios.FormActivate(Sender: TObject);
begin
 EdtNome.Text := nomeFunc;
end;

procedure TFrmUsuarios.FormShow(Sender: TObject);
begin
 desabilitarCampos;
 dm.tb_usuarios.Active := True;
 listar;
end;

procedure TFrmUsuarios.limpar;
begin
    EdtNome.Text := '';
    EdtUsuario.Text := '';
    EdtSenha.Text := '';
end;

procedure TFrmUsuarios.habilitarCampos;
begin

    EdtUsuario.Enabled := True;
    EdtSenha.Enabled := True;
    btnBuscarFuncionario.Enabled := True;

end;

procedure TFrmUsuarios.desabilitarCampos;
begin
    EdtNome.Enabled := False;
    EdtUsuario.Enabled := False;
    EdtSenha.Enabled := False;
    btnBuscarFuncionario.Enabled := False;
end;

procedure TFrmUsuarios.EdtBuscarNomeChange(Sender: TObject);
begin
 buscarNome;
end;

procedure TFrmUsuarios.verificaCadastro;
begin
    //verificar se o usuario j� est� cadastrado
    dm.query_usuarios.Close;
    dm.query_usuarios.SQL.Clear;
    dm.query_usuarios.SQL.Add('SELECT * FROM usuarios WHERE usuario = ' + QuotedStr(Trim(EdtUsuario.Text)));
    dm.query_usuarios.Open;
end;

procedure TFrmUsuarios.associarCampos;
begin
    dm.tb_usuarios.FieldByName('nome').Value := EdtNome.Text;
    dm.tb_usuarios.FieldByName('usuario').Value := EdtUsuario.Text;
    dm.tb_usuarios.FieldByName('senha').Value := EdtSenha.Text;
    dm.tb_usuarios.FieldByName('cargo').Value := cargoFunc;
    dm.tb_usuarios.FieldByName('id_funcionario').Value := idFunc;
end;

procedure TFrmUsuarios.listar;
begin
   dm.query_usuarios.Close;
    dm.query_usuarios.SQL.Clear;
    dm.query_usuarios.SQL.Add('SELECT * FROM usuarios  WHERE cargo <> :cargo order by nome asc');
    dm.query_usuarios.ParamByName('cargo').Value := 'admin';
    dm.query_usuarios.Open;
end;

procedure TFrmUsuarios.buscarNome;
begin
    dm.query_usuarios.Close;
    dm.query_usuarios.SQL.Clear;
    dm.query_usuarios.SQL.Add('SELECT * FROM usuarios WHERE nome LIKE :nome and cargo <> :cargo order by cargo asc');
    dm.query_usuarios.ParamByName('nome').Value := EdtBuscarNome.Text + '%';
     dm.query_usuarios.ParamByName('cargo').Value := 'admin';
    dm.query_usuarios.Open;
end;


procedure TFrmUsuarios.DBGrid1CellClick(Column: TColumn);
begin
    habilitarCampos;

    BtnEditar.Enabled := True;
    BtnExcluir.Enabled := True;

     dm.tb_usuarios.Edit;
    if dm.query_usuarios.FieldByName('nome').Value <> null then
    begin
     EdtNome.Text := dm.query_usuarios.FieldByName('nome').Value;
     EdtUsuario.Text := dm.query_usuarios.FieldByName('usuario').Value;
     EdtSenha.Text := dm.query_usuarios.FieldByName('senha').Value;
    end;

     id := dm.query_usuarios.FieldByName('id').Value;
     usuarioAntigo := dm.query_usuarios.FieldByName('usuario').Value;
end;

end.
