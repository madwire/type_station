require 'type_station/dsl'

TypeStation::DSL.build 'Homepage', template: 'index_other' do
  page 'About us' do
    page 'Team'
    page 'Contact us', redirect_to: '/contact-us'
    page 'Another Page Title', template: 'standard', slug: 'another-one'
  end
  page 'Contact us'
  page 'Projects', template: 'about_us'
end