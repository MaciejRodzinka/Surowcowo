module EntriesHelper
  def translate(name)
    translations = {
      coal: 'Węgiel',
      electricity: 'Prąd',
      gas: 'Gaz',
      pb95: 'Pb95', 
      pb98: 'Pb98',
      on: 'On',
      lpg: 'LPG'
    }

    translations[name.to_sym]
  end
end
