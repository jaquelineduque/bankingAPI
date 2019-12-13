### Passos para o deploy

Já com a última versão da API e as devidas ferramentas instaladas (Elixir, Erlang, Postgres e Phoenix), execute os passos abaixo.

1._Setar_ as variáveis de ambiente e executar o release (exemplo no Windows)
>SET APP_NAME=bank
SET SECRET_KEY_BASE="$(mix phx.gen.secret)"
SET MIX_ENV=prod
SET DATABASE_URL="postgresql://user:pass@localhost:5432/bank"
SET PORT=4000
mix release

### Deploy no Gigalixir:
1.1 Com o Gigalixir instalado execute o login
>gigalixir login

1.2 Crie seu app 
>gigalixir create --name bank

1.3. Crie sua base
>gigalixir pg:create -fr

2.4. Abra seu config/prod.exs e insira o nome do seu app no gigalixir mais o sufixo .gigalixirapp.com *
>config :bank, BankWeb.Endpoint,
  url: [host: "banking.gigalixirapp.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

2.5. Crie na raiz do seu projeto um arquivo com o nome "elixir_buildpack.config" que irá conter as versões do Elixir e Erlang utilizadas. *
>elixir_version=1.9.2
erlang_version=22.0.7


2.6. Verifique se seu arquivo prod.exs contém as informações do aplicativo e base, caso contrário às inclua.*
>config :bank, BankWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 80],
  database: "","SECRET_KEY_BASE"),
  secret_key_base: {:system, "SECRET_KEY_BASE"},
  server: true

>config :bank, Bank.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"},
  ssl: true,
  pool_size: 2

Atenção: Para as versões gratuitas do Gigalixir, manter o pool size como 2.

2.7. Caso esteja utilizando a versão gratuita do Gigalixir, verifique se o pool size está definido como 2 também no prods.secret *

> pool_size: String.to_integer(System.get_env("POOL_SIZE") || "2")

2.8. Commit suas alterações e execute o push para o Gigalixir
>gigalixir push gigalixir master

2.9. Com o console do Gigalixir rodando, execute a inserção dos dados iniciais para o funcionamento da API.
>seed_script = Path.join(["#{:code.priv_dir(:bank)}", "repo", "seeds.exs"])
Code.eval_file(seed_script)

Observações:
1.Os itens 2.4, 2.5, 2.6 e 2.8 já constam na versão corrente do bankingAPI. Desta forma, caso o código seja obtido através da última versão bastará pular estes itens.  
2.Caso você estaja no Windows pode ocorrer uma falha na compilação com a seguinte mensagem "(Mix) "nmake" not found in the path issue". Caso isto ocorra, será necessário instalar o compilador de C++ e através dele compilar a API.

Links úteis:
[Gigalixir](https://gigalixir.com/)
[Como abrir um console no Gigalixir](https://readthedocs.org/projects/gigalixir/downloads/pdf/latest/)
[(Mix) "nmake" not found in the path issue - Windows](https://lazacode.org/1395/mix-nmake-not-found-in-the-path-issue-windows)