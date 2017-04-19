describe Memory do
  it 'can be initialized with a hash'do
    subject = Memory.new({a: 'a'})
    expect(subject.a).to eq 'a'
  end

  it 'remembers what is given to it' do
    subject.a = 'a'
    expect(subject.a).to eq 'a'
  end

  it 'returns the value set' do
    value = subject.value = 'value'
    expect(value).to eq 'value'
  end

  it 'returns nil when it does not know something' do
    expect(subject.something).to be nil
  end

  it 'responds to any message' do
    expect(subject.responds_to(:whatever)).to be true
    expect(subject.responds_to(:whatever_else)).to be true
  end

  it 'can be converted to a hash' do
    subject.a = 'a'
    expect(subject.to_h).to eq({a: 'a'})
  end
end
