class AuthorSignature < Signature
  defaults :signature_role=> 'AUTHOR', :asserted_text=>SystemSettings.get('author_assert_text').text
end