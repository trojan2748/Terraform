


aws iam create-user --user-name Developer1
aws iam create-login-profile --user-name Developer1 --password XXX
aws iam create-group --group-name Developers
aws iam add-user-to-group --user-name Developer1 --group-name Developers
aws iam create-policy --policy-name Developers-Policy --policy-document file://IAM_Developers.json
aws iam attach-group-policy --policy-arn arn:aws:iam::362387340557:policy/Developers-Policy --group-name Developers


aws iam create-user --user-name DevOps1
aws iam create-login-profile --user-name DevOps1 --password XXX
aws iam create-group --group-name DevOps
aws iam add-user-to-group --user-name DevOps1 --group-name DevOps
aws iam create-policy --policy-name DevOps-Policy --policy-document file://../Chapter-9/IAM_Tools.json
aws iam attach-group-policy --policy-arn "arn:aws:iam::362387340557:policy/DevOps-Policy" --group-name DevOps
