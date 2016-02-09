require 'spec_helper'

describe Project::Omaha do
  it 'has a version number' do
    expect(Project::Omaha::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
