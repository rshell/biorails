class WitnessSignature < Signature
  defaults :signature_role=> 'WITNESS', :asserted_text=>SystemSetting.get('witness_assert_text').text
end