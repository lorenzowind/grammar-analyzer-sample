%{
  import java.io.*;
%}


%token INT DOUBLE BOOLEAN VOID FUNC WHILE IF ELSE num ident

%left '+' '-'
%left '*' '/'

%%

Prog : ListaDecl
     ;

ListaDecl : Decl
          |
          ;

Decl : DeclVar ListaDecl
     | DeclFun ListaDecl
     ;

DeclVar : Tipo ListaIdent ';'
        ;

Tipo : INT
     | DOUBLE
     | BOOLEAN
     ;

ListaIdent : ident ',' ListaIdent
           | ident
           ;

DeclFun : FUNC TipoOuVoid ident '(' FormalPar ')' Bloco
        ;

Bloco : '{' DeclVarOpt ListaCmdOpt '}'
      ;

DeclVarOpt : DeclVar ListaDecl
           |
           ;

ListaCmdOpt : ListaCmd
            |
            ;

TipoOuVoid : Tipo
           | VOID
           ;

FormalPar : ParamList
          |
          ;

ParamList : Tipo ident ',' ParamList
          | Tipo ident
          ;

ListaCmd : Cmd ListaCmd
         |
         ;

Cmd : Bloco
    | WHILE '(' E ')' Cmd
    | ident '=' E ';'
    | IF '(' E ')' Cmd RestoIf
    ;

RestoIf : ELSE Cmd
        |
        ;

E : E '+' T
  | E '-' T
  | T
  ;

T : T '*' F
  | T '/' F
  | F
  ;

F : ident
  | num
  | '(' E ')'
  ;

%%

  private Yylex lexer;


  private int yylex () {
    int yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e.getMessage());
    }
    return yyl_return;
  }


  public void yyerror (String error) {
    System.err.println ("Error: " + error);
  }


  public Parser(Reader r) {
    lexer = new Yylex(r, this);
  }


  static boolean interactive;

  public void setDebug(boolean debug) {
    yydebug = debug;
  }


  public static void main(String args[]) throws IOException {
    System.out.println("");

    Parser yyparser;
    if ( args.length > 0 ) {
      // parse a file
      yyparser = new Parser(new FileReader(args[0]));
    }
    else {System.out.print("> ");
      interactive = true;
	    yyparser = new Parser(new InputStreamReader(System.in));
    }

    yyparser.yyparse();

  //  if (interactive) {
      System.out.println();
      System.out.println("done!");
  //  }
  }