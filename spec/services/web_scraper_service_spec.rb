require 'rails_helper'

RSpec.describe WebScraperService do
  let(:html) { File.read(Rails.root.join('spec/fixtures/webmotors_page.html')) }

  before do
    allow(URI).to receive(:open).and_return(html)
  end

  it 'extrai corretamente o marca do veículo' do
    result = WebScraperService.scrape('https://www.webmotors.com.br/comprar/peugeot/208/16-griffe-16v-flex-4p-automatico/4-portas/2020/52049140?pos=a52049140g:&np=1&ct=1840177')
    expect(result[:make]).to eq('PEUGEOT')
  end

  it 'extrai corretamente o modelo do veículo' do
    result = WebScraperService.scrape('https://www.webmotors.com.br/comprar/peugeot/208/16-griffe-16v-flex-4p-automatico/4-portas/2020/52049140?pos=a52049140g:&np=1&ct=1840177')
    expect(result[:model]).to eq('208')
  end

  it 'extrai corretamente o preço do veículo' do
    result = WebScraperService.scrape('https://www.webmotors.com.br/comprar/peugeot/208/16-griffe-16v-flex-4p-automatico/4-portas/2020/52049140?pos=a52049140g:&np=1&ct=1840177')
    expect(result[:price]).to eq('R$ 70.990')
  end
end
