%Autor: Denilson Gomes Vaz da Silva
%Graduando em Engenharia da Computação
%Estudo sobre Evasão dp Curso de Engenharia de Computação

clear %limpa as variaveis
clc %limpa o visor 
close all

% Lendo os dados:
[fname path]=uigetfile('*.csv'); 
fname=strcat(path,fname);
% Preenchendo a tabela total tbl:
tbl = readtable(fname);

% Variavel dependente Y: Última coluna da tabela
% Dados X: Todas as colunas (exceto última)
X = tbl(:,1:end-1);
Y = tbl(:,end);
% Transforma o tipo tbl para arrays:
X = table2array(X)';
Y = table2array(Y)';

%Aplicando ELM com todas as caracteristicas levantadas
%separa o dataset em treino e teste
for i=1:17 
    XTreinamento = X; 
    YTreinamento = Y;
    for j=5:-1:1
        XTeste(:,j) = X(:,(i-1)*5 + j); %amostras para testar o modelo
        XTreinamento(:,(i-1)*5 + j) = []; %ficam so as amostras que vão treinar o modelo
        YTeste(:,j) = Y(:,(i-1)*5 + j); %classes para verificar acuracia do modelo
        YTreinamento(:,(i-1)*5 + j) = []; %ficam so as classes que vão treinar o modelo
    end
    %cria rede ELM com 30 camadas ocultas
    net = newelm(X,Y,30);
    
    %treinando a rede com tamTreino
    net = train(net,XTreinamento,YTreinamento);

    %testando a rede com os outros tamTeste
    yout = net(XTeste);
    %yout = round(yout); %podemos arredondar yout e comparar com Y
    %calcula acuracia
    acertos = 0; %acertos
    [~,tamTeste] = size(XTeste); %numero de testes
    for j=1:tamTeste
        if abs(yout(j) - YTeste(j)) < 0.9 %caso a rede neural tenha acertado
            acertos = acertos +1; %acrescenta acertos
        end
    end
    acuracia(i)=100*acertos/tamTeste; %acuracia obtida
    str = ['Acuracia obtida: ' num2str(acuracia(i)) ' %'];
    disp(str); %exibe a Acuracia obtida
end

str = ['Acuracia media obtida: ' num2str(mean(acuracia)) ' %'];
disp(str); %exibe a Acuracia obtida