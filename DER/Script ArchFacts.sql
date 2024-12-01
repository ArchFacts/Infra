DROP DATABASE ArchFacts;
CREATE DATABASE ArchFacts;
USE ArchFacts;


DROP TABLE IF EXISTS `Negocio`;

CREATE TABLE IF NOT EXISTS `Negocio` (
  `idNegocio` CHAR(36) NOT NULL,
  `nome` VARCHAR(125) NOT NULL,
  `codigo` VARCHAR(125) NOT NULL,
  `cep` CHAR(9) NOT NULL,
  `cpf` CHAR(11) NULL,
  `cnpj` CHAR(14) NULL,
  `dataRegistro` DATETIME NOT NULL,
  `avaliacao` INT(1) NULL,
  `ativado` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idNegocio`),
  UNIQUE INDEX `codigo_UNIQUE` (`codigo` ASC),
  UNIQUE INDEX `cep_UNIQUE` (`cep` ASC)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Usuario`;

CREATE TABLE IF NOT EXISTS `Usuario` (
  `idUsuario` CHAR(36) NOT NULL,
  `nome` VARCHAR(125) NOT NULL,
  `email` VARCHAR(125) NOT NULL,
  `senha` VARCHAR(125) NOT NULL,
  `telefone` CHAR(12) NOT NULL,
  `dataRegistro` DATETIME NOT NULL,
  `ativado` TINYINT NOT NULL,
  `role` VARCHAR(45) NOT NULL,
  `fkNegocio` CHAR(36),
  PRIMARY KEY (`idUsuario`),
  UNIQUE INDEX `telefone_UNIQUE` (`telefone` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  INDEX `fk_Usuario_Negocio_idx` (`fkNegocio` ASC),
  CONSTRAINT `fk_Usuario_Negocio`
    FOREIGN KEY (`fkNegocio`)
    REFERENCES `Negocio` (`idNegocio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Proposta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Proposta`;

CREATE TABLE IF NOT EXISTS `Proposta` (
  `idProposta` CHAR(36) NOT NULL,
  `titulo` varchar(100) NOT NULL,
  `cep` char(10) NOT NULL,
  `dataEntrega` DATETIME NULL,
  `dataEnvio` DATETIME NULL,
  `endereco` VARCHAR(100) NOT NULL,
  `numero` INTEGER(10) NOT NULL,
  `complemento` VARCHAR(100) NULL,
  `descricao` VARCHAR(250) NULL,
  `fkRemetente` CHAR(36) NOT NULL,
  `fkDestinatario` CHAR(36) NOT NULL,
  PRIMARY KEY (`idProposta`),
  INDEX `fk_Proposta_Usuario1_idx` (`fkRemetente` ASC),
  INDEX `fk_Proposta_Negocio1_idx` (`fkDestinatario` ASC),
  CONSTRAINT `fk_Proposta_Usuario1`
    FOREIGN KEY (`fkRemetente`)
    REFERENCES `Usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Proposta_Negocio1`
    FOREIGN KEY (`fkDestinatario`)
    REFERENCES `Negocio` (`idNegocio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Projeto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Projeto`;

CREATE TABLE IF NOT EXISTS `Projeto` (
  `idProjeto` CHAR(36) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(250) NULL,
  `custo` VARCHAR(45) NOT NULL,
  `dataInicio` DATETIME NOT NULL,
  `dataEntrega` DATETIME NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  `fkNegocio` CHAR(36) NOT NULL,
  `fkBeneficiario` CHAR(36) NOT NULL,
  PRIMARY KEY (`idProjeto`, `fkNegocio`),
  INDEX `fk_Projeto_Negocio1_idx` (`fkNegocio` ASC),
  INDEX `fk_Projeto_Usuario_idx` (`fkBeneficiario` ASC),
  CONSTRAINT `fk_Projeto_Negocio1`
    FOREIGN KEY (`fkNegocio`)
    REFERENCES `Negocio` (`idNegocio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_Projeto_Usuario`
    FOREIGN KEY (`fkBeneficiario`)
    REFERENCES `Usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Financeiro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Financeiro`;

CREATE TABLE IF NOT EXISTS `Financeiro` (
  `idFinanceiro` CHAR(36) NOT NULL,
  `lucroTotal` DOUBLE NOT NULL,
  `despesaTotal` DOUBLE NOT NULL,
  `Receita` DOUBLE NULL,
  `fkProjeto` CHAR(36) NOT NULL,
  PRIMARY KEY (`idFinanceiro`, `fkProjeto`),
  INDEX `fk_Financeiro_Projeto1_idx` (`fkProjeto` ASC),
  CONSTRAINT `fk_Financeiro_Projeto 1`
    FOREIGN KEY (`fkProjeto`)
    REFERENCES `Projeto` (`idProjeto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Chamado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Chamado`;

CREATE TABLE IF NOT EXISTS `Chamado` (
  `idChamado` CHAR(36) NOT NULL,
  `titulo` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(250) NOT NULL,
  `abertura` DATETIME NOT NULL,
  `fechamento` DATETIME NULL,
  `status` VARCHAR(45) NOT NULL,
  `lucro` DOUBLE NULL,
  `fkProjeto` CHAR(36) NOT NULL,
  PRIMARY KEY (`idChamado`, `fkProjeto`),
  INDEX `fk_Ticket_Projeto1_idx` (`fkProjeto` ASC),
  CONSTRAINT `fk_Ticket_Projeto1`
    FOREIGN KEY (`fkProjeto`)
    REFERENCES `Projeto` (`idProjeto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;
-- -----------------------------------------------------
-- Table `Tarefa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Tarefa`;

CREATE TABLE IF NOT EXISTS `Tarefa` (
  `idTarefa` CHAR(36) NOT NULL,
  `titulo` VARCHAr(45),
  `descricao` VARCHAR(250) NULL,
  `despesa` DOUBLE NULL,
  `dataInicio` DATETIME NULL,
  `dataTermino` DATETIME NULL,
  `prioridade` VARCHAR(45) NULL,
  `status` VARCHAR(45) NULL,
  `fkProjeto` CHAR(36) NOT NULL,
  PRIMARY KEY (`idTarefa`, `fkProjeto`),
  INDEX `fk_Tarefa_Projeto1_idx` (`fkProjeto` ASC),
  CONSTRAINT `fk_Tarefa_Projeto1`
    FOREIGN KEY (`fkProjeto`)
    REFERENCES `Projeto` (`idProjeto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Servico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Servico`;

CREATE TABLE IF NOT EXISTS `Servico` (
  `idServico` CHAR(36) NOT NULL,
  `nome` VARCHAR(45) NULL,
  `descricao` VARCHAR(250) NULL,
  `fkNegocio` CHAR(36) NOT NULL,
  PRIMARY KEY (`idServico`, `fkNegocio`),
  INDEX `fk_Servico_Negocio1_idx` (`fkNegocio` ASC),
  CONSTRAINT `fk_Servico_Negocio1`
    FOREIGN KEY (`fkNegocio`)
    REFERENCES `Negocio` (`idNegocio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table Intermediária `PropostaServico`
-- -----------------------------------------------------

CREATE TABLE PropostaServico (
    idPropostaServico CHAR(36) PRIMARY KEY, 
    idProposta CHAR(36) NOT NULL,           
    fkRemetente CHAR(36),                   
    fkDestinatario CHAR(36),                
    idServico CHAR(36) NOT NULL,            
    fkNegocio CHAR(36),                     
    dataCriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    --  Keys
    CONSTRAINT fk_Proposta FOREIGN KEY (idProposta) REFERENCES Proposta(idProposta) ON DELETE CASCADE,
    CONSTRAINT fk_Servico FOREIGN KEY (idServico) REFERENCES Servico(idServico),

    CONSTRAINT fk_Remetente FOREIGN KEY (fkRemetente) REFERENCES Usuario(idUsuario),
    CONSTRAINT fk_Destinatario FOREIGN KEY (fkDestinatario) REFERENCES Negocio(idNegocio),
    CONSTRAINT fk_Negocio FOREIGN KEY (fkNegocio) REFERENCES Negocio(idNegocio)
);


-- -----------------------------------------------------
-- Table `Evento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Evento`;

CREATE TABLE IF NOT EXISTS `Evento` (
  `idEvento` CHAR(36) NOT NULL,
  `dataInicio` VARCHAR(45) NULL,
  `dataTermino` VARCHAR(45) NULL,
  `dataCriacao` VARCHAR(45) NULL,
  `tipo` VARCHAR(45) NULL,
  `descricao` VARCHAR(45) NULL,
  `status` VARCHAR(45) NULL,
  `fkProjeto` CHAR(36) NOT NULL,
  `fkNegocio` CHAR(36) NOT NULL,
  PRIMARY KEY (`idEvento`, `fkProjeto`, `fkNegocio`),
  INDEX `fk_Evento_Projeto1_idx` (`fkProjeto` ASC, `fkNegocio` ASC),
  CONSTRAINT `fk_Evento_Projeto1`
    FOREIGN KEY (`fkProjeto`, `fkNegocio`)
    REFERENCES `Projeto` (`idProjeto`, `fkNegocio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Parcela`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parcela`;

CREATE TABLE IF NOT EXISTS `Parcela` (
  `idParcela` CHAR(36) NOT NULL,
  `valor` DOUBLE NULL,
  `dataInicio` DATETIME NULL,
  `dataTermino` DATETIME NULL,
  `status` VARCHAR(45) NULL,
  `fkChamado` CHAR(36) NOT NULL,
  `fkProjeto` CHAR(36) NOT NULL,
  PRIMARY KEY (`idParcela`, `fkChamado`, `fkProjeto`),
  INDEX `fk_Parcela_Chamado1_idx` (`fkChamado` ASC, `fkProjeto` ASC),
  CONSTRAINT `fk_Parcela_Chamado1`
    FOREIGN KEY (`fkChamado`, `fkProjeto`)
    REFERENCES `Chamado` (`idChamado`, `fkProjeto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

describe Usuario;
select * from usuario;
describe negocio;

select * from usuario;

SELECT u.nome, u.email, u.telefone, u.dataRegistro, u.ativado, u.role, n.nome 
FROM Usuario u 
LEFT JOIN Negocio n ON u.fkNegocio = n.idNegocio 
WHERE u.email = '';

insert into Usuario values (
'e0c1691c-997e-4eca-8168-c73274319af1',
 'Júlia Campioto',
 'juliacampioto@gmail.com',
 '$2a$10$AtZPLBMh5Q4DPDsUJRSy9.KPt0gSkgZJtZ.oP2gZ95SOr0nfVZpMO',
 '11984057602',
 '2024-11-24 02:53:12',
 1,
 'USER',
 null);
 
INSERT INTO Proposta (idProposta, conteudo, dataEnvio, fkRemetente, fkDestinatario)
VALUES (
    'a5d16547-ff39-4c77-9d4b-3e8c6fa803d9', -- ID único para a proposta
    'Proposta para o serviço de consultoria.', -- Conteúdo da proposta
    NOW(), -- Data de envio (data e hora atual),
    (SELECT idUsuario FROM Usuario WHERE email = 'juliacampioto@gmail.com'), -- ID do remetente
    ('07a41013-ac2d-45c4-92db-76935c506756') -- ID do destinatário (negócio)
);

select * from usuario;
select * from negocio;
select * from proposta;
select * from servico;
select * From propostaServico;

SELECT 
    p.idProposta,
    p.titulo AS tituloProposta,
    p.dataEnvio,
    ps.idServico,
    s.nome AS nomeServico,
    s.descricao AS descricaoServico,
    n.nome AS nomeNegocio
FROM 
    Proposta p
INNER JOIN 
    PropostaServico ps ON p.idProposta = ps.idProposta
INNER JOIN 
    Servico s ON ps.idServico = s.idServico
INNER JOIN 
    Negocio n ON p.fkDestinatario = n.idNegocio
WHERE 
    n.idNegocio = '68372141-39e3-4ea8-afb0-e2f4ec8aadc7';
    
    select * from propostaServico;
    select * from proposta;
    select * From projeto;
    select * From tarefa;
    select * from chamado;
    
    select * from tarefa join Projeto on idProjeto = fkProjeto where idProjeto = '109feb09-e5be-4d43-9d8b-9e1171a083e8';