require 'spec_helper'
require 'type_station/dsl'

RSpec.describe TypeStation::DSL do

  before do

    TypeStation::DSL.build 'Homepage' do
      page 'About us' do
        page 'Team'
        page 'Contact us', redirect_to: '/contact-us'
        page 'Another Page Title', template: 'standard', slug: 'another-one'
      end
      page 'Contact us'
      page 'Projects', template: 'about_us'
    end

  end


  it 'will create an index page' do
    expect(TypeStation::Page.root.title).to eq('Homepage')
  end

  it 'will set the index page template to index' do
    expect(TypeStation::Page.root.template_name).to eq('index')
  end

  it 'will create 3 children for the root page' do
    expect(TypeStation::Page.root.children.count).to eq(3)
  end

  it 'will set the about us page template name to about_us' do
    expect(TypeStation::Page.find_by_path('/about-us').template_name).to eq('about_us')
  end

  it 'will set the projects page template to about-us' do
    expect(TypeStation::Page.find_by_path('/projects').template_name).to eq('about_us')
  end

  it 'will set the about-us/contact-us page redirect_to to /contact-us' do
    expect(TypeStation::Page.find_by_path('about-us/contact-us').redirect_to).to eq('/contact-us')
  end

  it 'will create children of children' do
    expect(TypeStation::Page.find_by_path('/about-us/team')).to eq(TypeStation::Page.where(title: 'Team').first)
  end

  it 'will create a page with a defined slug' do
    expect(TypeStation::Page.find_by_path('/about-us/another-one')).to eq(TypeStation::Page.where(title: 'Another Page Title').first)
  end

end