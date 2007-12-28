class AuthorSignature < Signature
  defaults :signature_role=> 'AUTHOR', :asserted_text=>SystemSetting.get('author_assert_text').text
end