class WitnessSignature < Signature
  defaults :signature_role=> 'WITNESS', :asserted_text=>SystemSettings.get('witness_assert_text').text
end