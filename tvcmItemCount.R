library(tidyverse)
library(openxlsx)

load("~/IS2022/R_data/Rdata.win/テレビCM出稿データ_2022.Rdata")
# CM製品数の一覧とそれぞれのCM数のリストをtvskから作成
itemSummary<-tvsk %>% select(item_name) %>% group_by(item_name) %>% summarise(cnt=n()) %>%
  arrange(item_name)

# 作成された化粧品リストの読み込み
cosmeCM<-read.xlsx("D:/documents/IS2022/cm出稿データ＿化粧品 (1).xlsx") %>% 
  filter(item_name != "企業")
# 作成されたものからCM製品数の一覧とそれぞれのCM数を出す
cosmeList<-cosmeCM %>% group_by(item_name) %>% summarise(cnt=n()) %>% arrange(item_name) 

# tvskから読み込んだデータ内の作成された化粧品リストに該当するものを取り出し
# cosmeCM(作成されたリストのみから作成)とcosmeCM2(tvskと作成されたリストとから作成)が
# 一致することを確認
cosmeCM2<-tvsk %>% filter(item_name %in% cosmeList$item_name)

# 番組名と局名と製品名のリスト
cosmeCMprog<- cosmeCM %>% arrange(title_name, column_text) %>% 
  select(title_name, column_text, item_name)

# 番組名と局名の組み合わせでそれぞれ何回CMを打たれているか？
cosmeCMprogCnt<-cosmeCMprog %>% group_by(title_name, column_text) %>% summarise(cnt=n())

# 番組の繰り返しを区別せず番組名を取り出し集計する試み
# スペース、【、」で区切って、先頭のみを取り出す。
tmp<-sapply(cosmeCMprog$title_name,function(x) str_split(x," |【|」")[[1]][1])
# 区切った名前の数を数える
paste("番組数の近似値",length(unique(tmp)))
# 区切った名前の列をデータフレームに加える
tmp2<-cbind(tmp, cosmeCMprog)
# 区切った名前と局名の組み合わせでcm数を数える。
cosmeCMprogCnt2<-tmp2 %>% group_by(tmp, column_text) %>% summarise(title_name, cnt=n()) %>% 
  group_by(tmp, title_name, column_text, cnt) %>% summarise()
