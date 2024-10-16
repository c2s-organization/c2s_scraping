require 'rails_helper'

RSpec.describe WebScraperService do

  before do
    # TODO: Acesso ao site original
    allow(NotifyService).to receive(:call).and_return(true)
  end

  it 'extrai corretamente o marca do veículo' do
    result = WebScraperService.scrape('https://www.webmotors.com.br/comprar/peugeot/208/16-griffe-16v-flex-4p-automatico/4-portas/2020/52049140?pos=a52049140g:&np=1&ct=1840177')
    expect(result[:make]).to eq('PEUGEOT')
    expect(result[:model]).to eq('208')
    expect(result[:price]).to eq('R$ 70.990')
  end

  it 'extrai corretamente o modelo do veículo' do
    result = WebScraperService.scrape('https://www.webmotors.com.br/comprar/byd/king/15-dm-i-phev-gs-automatico/4-portas/2024-2025/53987515?pos=b53987515m:&np=1')
    expect(result[:make]).to eq('BYD')
    expect(result[:model]).to eq('KING')
    expect(result[:price]).to eq('R$ 277.800')
  end

  it 'extrai corretamente o preço do veículo' do
    result = WebScraperService.scrape('https://www.webmotors.com.br/comprar/mclaren/750s/40-v8-turbo-gasolina-spider-ssg/2-portas/2024/53972021?pos=a53972021g:&np=1')
    expect(result[:make]).to eq('MCLAREN')
    expect(result[:model]).to eq('750S')
    expect(result[:price]).to eq('R$ 4.500.000')
  end
end
