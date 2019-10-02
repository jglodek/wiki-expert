# encoding: utf-8

def polish_wiki_stopwords
   ['category','expert','zagrożenia','aplikacje','rozwiązania', 'w','i','z','za','są','to','je','itp','do','od','a','po','na','i','o','co','nr','aby', 'ach', 'acz', 'aczkolwiek', 'albo', 'ale', 'ależ', 'bardziej', 'bardzo', 'bez',
  'bowiem', 'byli', 'bynajmniej', 'być', 'był', 'była', 'było', 'były', 'będzie', 'będą' ,
  'cali', 'cała', 'cały', 'cię', 'ciebie', 'cokolwiek', 'coś', 'czasami', 'czasem', 'czemu' ,
  'czy', 'czyli', 'daleko', 'dla', 'dlaczego', 'dlatego', 'dobrze', 'dokąd', 'dość', 'dużo' ,
  'dwa', 'dwaj', 'dwie', 'dwoje', 'dziś', 'dzisiaj', 'gdy', 'gdyby', 'gdyż', 'gdzie' ,
  'gdziekolwiek', 'gdzieś', 'ich', 'ile', 'inna', 'inne', 'inny','innymi', 'innych', 'jak', 'jakaś' ,
  'jakby', 'jaki', 'jakichś', 'jakie', 'jakiś', 'jakiż', 'jakkolwiek', 'jako', 'jakoś' ,
  'jeden', 'jedna', 'jedno', 'jednak', 'jednakże', 'jego', 'jej', 'jemu', 'jest', 'jestem' ,
  'jeszcze', 'jeśli', 'jeżeli', 'już', 'każdy', 'kiedy', 'kilka', 'kimś', 'kto', 'ktokolwiek' ,
  'ktoś', 'która', 'które', 'którego', 'której', 'który', 'których', 'którym', 'którzy', 'lat' ,
  'lecz', 'lub', 'mają', 'mam', 'mimo', 'między', 'mną', 'mnie', 'mogą', 'moi', 'moim', 'moja' ,
  'moje', 'może', 'możliwe', 'można', 'mój', 'musi', 'nad', 'nam', 'nami', 'nas', 'nasi', 'nasz' ,
  'nasza', 'nasze', 'naszego', 'naszych', 'natomiast', 'natychmiast', 'nawet', 'nią', 'nic' ,
  'nich', 'nie', 'niego', 'niej', 'niemu', 'nigdy', 'nim', 'nimi', 'niż', 'obok', 'około', 'ona' ,
  'one', 'oni', 'ono', 'oraz', 'owszem', 'pan', 'pana', 'pani', 'pod', 'podczas', 'pomimo', 'ponad' ,
  'ponieważ', 'powinien', 'powinna', 'powinni', 'powinno', 'poza', 'prawie', 'przecież' ,
  'przed', 'przede', 'przedtem', 'przez', 'przy', 'roku', 'również', 'sam', 'sama', 'się' ,
  'skąd', 'sobie', 'sobą', 'sposób', 'swoje', 'tak', 'taka', 'taki', 'takie', 'także', 'tam' ,
  'tego', 'tej', 'ten', 'teraz', 'też', 'totobą', 'tobie', 'toteż', 'trzeba', 'tutaj', 'twoi' ,
  'twoim', 'twoja', 'twoje', 'twym', 'twój', 'tych', 'tylko', 'tym', 'wam', 'wami', 'was', 'wasz' ,
  'wasza', 'wasze', 'według', 'wiele', 'wielu', 'więc', 'więcej', 'wszyscy', 'wszystkich' ,
  'wszystkie', 'wszystkim', 'wszystko', 'wtedy', 'właśnie', 'zapewne', 'zawsze', 'zeznowu' ,
  'znów', 'został', 'żaden', 'żadna', 'żadne', 'żadnych', 'żeby', 'r', 'ref','ponownie']
end

class Stemmer
  # http://grzegorj.w.interia.pl/gram/pl/slowotw04.html
  # + wlasne
  #  [WZORZEC, ZASTĘPSTWO]
  def self.suffix_rules
    [
      ["emu", "em"],
      ["cą", "c"],
      ["inu", "in"],
      ["istych", "iste"],
      ["pu", "p"],
      ["dów", "d"],
      ["onę", "ona"],
      ["dzący", "d"],
      ["ołu", "uł"],
      ["ują", "anie"],
      ["ęć", "ęcia"],
      ["ości", "ość"],
      ["wał", "anie"],
      ["eksie", "eks"],
      ["eku", "ek"],
      ["ściowych", "ść"],
      ["ailu", "ail"],
      ["ujący", ""],
      ["ingiem", ""],
      ["ingowi", ""],
      ["yjski", ""],
      ["owski", ""],
      ["owaty", ""],
      ["ański", ""],
      ["ijski", ""],
      ["iński", ""],
      ["iczny", ""],
      ["eński", ""],
      ["arski", ""],
      ["niczy", ""],
      ["awczy", ""],
      ["yczny", ""],
      ["ingu", ""],
      ["liwy", ""],
      ["ysty", ""],
      ["elny", ""],
      ["alny", ""],
      ["arny", ""],
      ["yjny", ""],
      ["isty", ""],
      ["ijny", ""],
      ["iny", ""],
      ["cki", ""],
      ["awy", ""],
      ["ing", ""],
      ["czy", ""],
      ["aty", ""],
      ["any", ""],
      ["yny", ""],
      ["owy", ""],
      ["ski", ""],
      ["ny", ""],
      ["ły", ""]
    ]
  end

  def self.stem(word)
    result = word
    l = word.length
    suffix_rules.each do |rule|
      sl = rule[0].length
      if(word[l-sl,sl] == rule[0])
        return word[0,l-sl]+rule[1]
      end
    end
    result
  end
end

class String
  def stem
    return Stemmer.stem(self)
  end
end
