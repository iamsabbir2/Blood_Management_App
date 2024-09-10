import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() {
    return _AccountState();
  }
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.white,
            ),
        title: const Text(
          'Account',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Security notifications'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const SecurityNotifications();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.key_outlined),
            title: const Text('Passkey'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const Passkeys();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email address'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const EmailAddress();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.password_outlined),
            title: const Text('Two-step verification'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const TwoStepVerification();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.security_update_outlined),
            title: const Text('Change number'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const ChangeNumber();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_quote),
            title: const Text('Request account info'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return const RequestInfo();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_remove_alt_1_outlined),
            title: const Text('Remove account'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const RemoveAccount();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete account'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const DeleteAccount();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() {
    return _DeleteAccountState();
  }
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.white,
            ),
        title: const Text(
          'Delete this account',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text('Delete this account'),
      ),
    );
  }
}

class RemoveAccount extends StatefulWidget {
  const RemoveAccount({super.key});

  @override
  State<RemoveAccount> createState() {
    return _RemoveAccountState();
  }
}

class _RemoveAccountState extends State<RemoveAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.white,
            ),
        title: const Text(
          'Remove account',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text('Remove account'),
      ),
    );
  }
}

class RequestInfo extends StatefulWidget {
  const RequestInfo({super.key});

  @override
  State<RequestInfo> createState() {
    return _RequestInfoState();
  }
}

class _RequestInfoState extends State<RequestInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.white,
            ),
        title: const Text(
          'Request account info',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text('Request account info'),
      ),
    );
  }
}

class ChangeNumber extends StatefulWidget {
  const ChangeNumber({super.key});

  @override
  State<ChangeNumber> createState() {
    return _ChangeNumberState();
  }
}

class _ChangeNumberState extends State<ChangeNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.white,
            ),
        title: const Text(
          'Change number',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text('Change number'),
      ),
    );
  }
}

class TwoStepVerification extends StatefulWidget {
  const TwoStepVerification({super.key});

  @override
  State<TwoStepVerification> createState() {
    return _TwoStepVerificationState();
  }
}

class _TwoStepVerificationState extends State<TwoStepVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.white,
            ),
        title: const Text(
          'Two-step verification',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text('Two-step verification'),
      ),
    );
  }
}

class EmailAddress extends StatefulWidget {
  const EmailAddress({super.key});

  @override
  State<EmailAddress> createState() {
    return _EmailAddressState();
  }
}

class _EmailAddressState extends State<EmailAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.white,
            ),
        title: const Text(
          'Email address',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text('Email address'),
      ),
    );
  }
}

class Passkeys extends StatefulWidget {
  const Passkeys({super.key});

  @override
  State<Passkeys> createState() {
    return _PasskeysState();
  }
}

class _PasskeysState extends State<Passkeys> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.white,
            ),
        title: const Text(
          'Passkeys',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text('Passkeys'),
      ),
    );
  }
}

class SecurityNotifications extends StatefulWidget {
  const SecurityNotifications({super.key});

  @override
  State<SecurityNotifications> createState() {
    return _SecurityNotificationsState();
  }
}

class _SecurityNotificationsState extends State<SecurityNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.white,
            ),
        title: const Text(
          'Security notifications',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text('Security notifications'),
      ),
    );
  }
}
