Aws.config[:ses] = {
  stub_responses: {
    get_identity_verification_attributes: {
      verification_attributes: {
        'example.com' => { verification_status: 'Success' }
      }
    },

    verify_domain_identity: {
      verification_token: 'G8qYlxUb5fkAus3eY/tp83XPKI0RvChrEfjYl4aEn7s='
    },

    verify_domain_dkim: {
      dkim_tokens: %w(
        todq4lvd66ptvcfkpgtxo26nx53fkuce
        g3jkkqxckrfukxvmyvz43annasly3ccq
        vfk7s2mxgg27m7vu5npsh7opco6x66rw
      )
    },

    get_identity_dkim_attributes: {
      dkim_attributes: {
        'example.com' => {
          dkim_enabled: false,
          dkim_verification_status: 'Success'
        }
      }
    },

    get_identity_mail_from_domain_attributes: {
      mail_from_domain_attributes: {
        'example.com' => {
          behavior_on_mx_failure: 'UseDefaultValue',
          mail_from_domain: 'bounce.example.com',
          mail_from_domain_status: 'Success'
        }
      }
    }
  }
}

Aws.config[:sns] = {
  stub_responses: {
    create_topic: {
      topic_arn: 'arn:aws:sns:us-east-1:495707395447:mailkiq'
    }
  }
}

Aws.config[:sqs] = {
  stub_responses: {
    create_queue: {
      queue_url: 'https://sqs.us-east-1.amazonaws.com/495707395447/mailkiq'
    },

    get_queue_attributes: {
      attributes: { 'QueueArn' => 'arn:aws:sqs:us-east-1:495707395447:mailkiq' }
    }
  }
}
