library(tidyverse)
library(openxlsx)

load("~/IS2022/R_data/Rdata.win/�e���rCM�o�e�f�[�^_2022.Rdata")
# CM���i���̈ꗗ�Ƃ��ꂼ���CM���̃��X�g��tvsk����쐬
itemSummary<-tvsk %>% select(item_name) %>% group_by(item_name) %>% summarise(cnt=n()) %>%
  arrange(item_name)

# �쐬���ꂽ���ϕi���X�g�̓ǂݍ���
cosmeCM<-read.xlsx("D:/documents/IS2022/cm�o�e�f�[�^�Q���ϕi (1).xlsx") %>% 
  filter(item_name != "���")
# �쐬���ꂽ���̂���CM���i���̈ꗗ�Ƃ��ꂼ���CM�����o��
cosmeList<-cosmeCM %>% group_by(item_name) %>% summarise(cnt=n()) %>% arrange(item_name) 

# tvsk����ǂݍ��񂾃f�[�^���̍쐬���ꂽ���ϕi���X�g�ɊY��������̂����o��
# cosmeCM(�쐬���ꂽ���X�g�݂̂���쐬)��cosmeCM2(tvsk�ƍ쐬���ꂽ���X�g�Ƃ���쐬)��
# ��v���邱�Ƃ��m�F
cosmeCM2<-tvsk %>% filter(item_name %in% cosmeList$item_name)

# �ԑg���Ƌǖ��Ɛ��i���̃��X�g
cosmeCMprog<- cosmeCM %>% arrange(title_name, column_text) %>% 
  select(title_name, column_text, item_name)

# �ԑg���Ƌǖ��̑g�ݍ��킹�ł��ꂼ�ꉽ��CM��ł���Ă��邩�H
cosmeCMprogCnt<-cosmeCMprog %>% group_by(title_name, column_text) %>% summarise(cnt=n())

# �ԑg�̌J��Ԃ�����ʂ����ԑg�������o���W�v���鎎��
# �X�y�[�X�A�y�A�v�ŋ�؂��āA�擪�݂̂����o���B
tmp<-sapply(cosmeCMprog$title_name,function(x) str_split(x," |�y|�v")[[1]][1])
# ��؂������O�̐��𐔂���
paste("�ԑg���̋ߎ��l",length(unique(tmp)))
# ��؂������O�̗���f�[�^�t���[���ɉ�����
tmp2<-cbind(tmp, cosmeCMprog)
# ��؂������O�Ƌǖ��̑g�ݍ��킹��cm���𐔂���B
cosmeCMprogCnt2<-tmp2 %>% group_by(tmp, column_text) %>% summarise(title_name, cnt=n()) %>% 
  group_by(tmp, title_name, column_text, cnt) %>% summarise()